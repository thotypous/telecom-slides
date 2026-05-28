#import "@preview/polylux:0.4.0": *
#import "@preview/fletcher:0.5.7" as fletcher: node, edge
#import "@preview/cetz:0.3.4": canvas
#import "@preview/cetz-plot:0.1.1": plot

#set page(paper: "presentation-16-9")
#set text(font: "Inria Sans", size: 25pt, lang: "pt", region: "br")

// ============================================================
// SLIDE 1 — Capa
// ============================================================
#slide[
  #align(horizon + center)[
    = Tecnologia de Comunicação

    Módulo 5 -- Rádio Definido por Software, Wi-Fi, OFDM \
    e recepção IEEE 802.11

    #text(size: 18pt)[Da amostra I/Q capturada no SDR aos bits de um quadro Wi-Fi]

    Prof. Paulo Matias
  ]
]

// ============================================================
// SLIDE 2 — Objetivos
// ============================================================
#slide[
  == Objetivos deste módulo

  #set text(size: 16.5pt)

  Ao fim desta aula, o aluno deve saber responder:

  - O que é _Software Defined Radio_ (SDR) e onde fica a fronteira entre RF analógico, conversores e DSP.
  - Como um receptor SDR pode ser construído com blocos simples: filtros, misturadores, osciladores, ADCs e processamento I/Q.
  - Por que Wi-Fi 802.11a/g usa _Orthogonal Frequency-Division Multiplexing_ (OFDM), prefixo cíclico (CP), preâmbulo, treinamento e pilotos.
  - Quais defeitos (_impairments_) o sinal sofre e qual bloco do receptor corrige cada um.
  - Como cada transformação no código da prática modifica o sinal e por que ela funciona.
  - Como funcionam códigos convolucionais binários (BCC), Viterbi com _soft-decision_ e _Low-Density Parity-Check_ (LDPC) com passagem de mensagens.
]

// ============================================================
// SLIDE 3 — O que já veio antes
// ============================================================
#slide[
  == O que não vamos repetir do zero

  #set text(size: 16.3pt)

  Este módulo reaproveita conceitos já trabalhados:

  - I/Q, PSK/QAM, constelações, BER, SNR e $E_b\/N_0$.
  - AWGN, ruído térmico, figura de ruído e orçamento de enlace.
  - CRC, GF(2), LFSR e diferença entre detecção e correção de erros.
  - ISI, equalização, sincronismo de portadora, erro de fase/frequência e erro de temporização.
  - FFT/IFFT já apareceram em outros contextos; aqui elas viram o coração do modem.

  #v(0.4em)
  #text(size: 14pt)[A novidade é integrar tudo em uma PHY Wi-Fi real: o sinal chega como amostras complexas e sai como bytes de um quadro MAC.]
]

// ============================================================
// SLIDE 4 — Visão da prática
// ============================================================
#slide[
  == Prática 5: problema concreto

  #set text(size: 15pt)

  // Descrição para acessibilidade: diagrama horizontal. À esquerda, três fontes de amostras complexas I/Q: simulação com transmissor e canal, arquivo NPZ de trechos gravados e arquivo I/Q bruto capturado por SDR. As três setas convergem e entram em um bloco "receptor OFDM 802.11a/g". Dentro dele aparece uma sequência horizontal: detecção de pacote, correção de frequência, correlação da sequência longa, FFT, equalização, pilotos, demapper soft, deinterleaver, Viterbi e descrambler. À direita saem o campo SIGNAL, os bytes do PSDU, a verificação de cauda e a verificação de CRC.
  #align(center)[#image("fig/pratica_pipeline.svg", width: 96%)]
  #v(-0.2em)

  A prática implementa um receptor 802.11a/g em Python:

  - Entrada: vetor `complex64` com amostras I/Q em banda base.
  - Saída: campo `SIGNAL`, dados MAC, verificação de cauda e CRC.
  - Modo sintético: transmissor, modelo de defeitos, receptor e EVM (_Error Vector Magnitude_).
  - Modo SDR: captura com LimeSDR/GNU Radio e processamento offline.
]

// ============================================================
// SLIDE 5 — SDR como arquitetura
// ============================================================
#slide[
  == SDR: onde colocar o software?

  #set text(size: 18pt)
  #grid(
    columns: (1.5fr, 1fr),
    gutter: 1em,
    [
      SDR não significa "sem RF analógico".

      - A antena, filtros, LNA/VGA, misturadores e osciladores continuam existindo.
      - O que muda é a fronteira: mais funções passam a ser parametrizadas ou implementadas em DSP.
      - Quanto mais cedo se amostra, maior a taxa e a exigência do ADC.
      - Quanto mais tarde se amostra, mais rígido fica o hardware analógico.

      #v(0.5em)
      #text(size: 14pt)[Em Wi-Fi, o receptor físico é quase sempre uma combinação: front-end RF dedicado + ADC/DAC + DSP/FPGA/CPU.]
    ],
    [
      // Descrição para acessibilidade: This image displays block diagrams for three different radio receiver architectures. The diagrams are arranged vertically, one below the other. Each diagram traces the path of a signal from an antenna on the far left to a "Digital Signal Processing" block on the far right.
      // Detalhes: no diagrama Superhet, a antena passa por filtro passa-faixa, amplificador, misturador com LO, outro filtro passa-faixa, segundo misturador com LO, conversor A/D e DSP. No diagrama Direct Conversion, antena, filtro e amplificador alimentam dois ramos I e Q com misturadores, filtros passa-baixa e conversores A/D antes do DSP. No diagrama Direct Sampling, antena, filtro e amplificador alimentam diretamente um conversor A/D e um bloco DSP maior.
      #align(center)[
        #image("fig/radio_architectures.png", width: 100%)
        #v(-0.6em)
        #text(size: 8pt)[Stefan, _The Direct Sampling SDR Architecture_, obtido de #link("https://panoradio-sdr.de/direct-sampling/")[panoradio-sdr.de].]
      ]
    ]
  )
]

// ============================================================
// SLIDE 6 — Três arquiteturas de recepção
// ============================================================
#slide[
  == Três arquiteturas de recepção

  #set text(size: 12.7pt)
  #table(
    columns: (0.85fr, 1.45fr, 1.45fr, 1.45fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Arquitetura*], [*Ideia*], [*Vantagem*], [*Risco*]),
    [Super-heteródino], [converte RF para uma ou mais FI antes do ADC], [seletividade analógica e bom isolamento], [mais filtros, LOs e calibração],
    [Conversão direta], [mistura direto para I/Q em banda base], [simples e compatível com ADCs moderados], [offset DC, vazamento de LO e desequilíbrio I/Q],
    [Amostragem direta], [ADC vê RF ou uma FI larga], [máxima flexibilidade em software], [ADC rápido, faixa dinâmica alta, aliasing exigente],
  )

  #v(0.5em)
  #set text(size: 16pt)
  - Muitos SDRs de laboratório usam conversão direta ou FI baixa.
  - LimeSDR: RFIC configurável, conversores e FPGA; o host recebe amostras I/Q.
  - O código da prática começa depois dessa fronteira: já recebe banda base complexa.
]

// ============================================================
// SLIDE 7 — LimeSDR
// ============================================================
#slide[
  == LimeSDR na Prática 5

  #set text(size: 15.2pt)

  // Descrição para acessibilidade: diagrama da esquerda para a direita. Uma antena Wi-Fi entra no front-end RF do LimeSDR, com filtros, amplificadores, misturadores I/Q e oscilador local configurável. Em seguida aparecem ADCs I e Q, FPGA e interface USB para o computador. No computador, GNU Radio mostra espectro/constelação e grava um arquivo de amostras I/Q; depois o script Python lê esse arquivo e executa o receptor 802.11a/g.
  #align(center)[#image("fig/limesdr_architecture.svg", width: 97%)]
  #v(-0.2em)

  O LimeSDR não decodifica Wi-Fi sozinho neste módulo:

  - Ele sintoniza o canal, ajusta ganho e entrega amostras I/Q.
  - O GNU Radio ajuda a visualizar espectro, validar captura e salvar arquivo.
  - O Python implementa a parte didática do receptor: sincronização, OFDM e bits.
  - A captura real inclui imperfeições que a simulação tenta imitar.

  #v(0.2em)
  #text(size: 13.5pt)[Hardware para observar o mundo real, software para abrir a caixa-preta do modem.]
]

// ============================================================
// SLIDE 8 — SDRZero
// ============================================================
#slide[
  #set text(size: 13.2pt)

  // Descrição para acessibilidade: esquema elétrico completo do SDRZero, receptor SDR brasileiro de 2006 para a faixa de 40 m. O circuito está dividido visualmente em blocos funcionais: no topo esquerdo há reguladores de tensão; na linha de RF, a antena passa por filtro passa-faixa, pré-amplificador, transformador de RF e detector por amostragem em quadratura com o circuito integrado U1. Na parte inferior há o oscilador local, conversor senóide-quadrada e contador Johnson U5 que gera fases 0, 90, 180 e 270 graus para comandar o QSD. À direita, amplificadores de instrumentação geram as saídas de áudio I e Q, chamadas Right e Left, para a placa de som do computador.
  #align(center)[
    #image("fig/SDRZero.png", width: 75%)
    #v(-0.7em)
    #text(size: 8pt)[J. K. De Marco e Edson W. Pereira, _SDRZero_; esquema em #link("https://wabicafe.com.br/py2sdr/SDRZero/SDRZero_2.php")[wabicafe.com.br].]
  ]
]

// ============================================================
// SLIDE 9 — Lendo o SDRZero
// ============================================================
#slide[
  == Como ler o circuito do SDRZero

  #set text(size: 11.8pt)

  #table(
    columns: (0.96fr, 1.30fr, 2.25fr),
    inset: 4pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Bloco no esquema*], [*Função*], [*Ponto didático*]),
    [Filtro de entrada], [limita sinais antes do detector], [reduz produtos espúrios quando há sinais fortes fora da banda],
    [Pré-amplificador RF], [ganho e isolamento em RF], [sensibilidade não é só ganho: ruído, impedância e vazamento de LO importam],
    [Guanella], [interface entre RF e chaves], [transforma a impedância e alimenta o detector de forma balanceada],
    [FST3253 / QSD], [chaves amostram a RF em 0°, 90°, 180° e 270°], [não é mixer multiplicador convencional; gera I/Q em áudio com baixa perda],
    [Oscilador local], [gera a referência senoidal], [estabilidade e ruído de fase do LO aparecem diretamente no áudio I/Q],
    [Conversor senóide-quadrada], [prepara nível lógico para o contador], [o QSD precisa de chaves comandadas por transições digitais limpas],
    [Contador Johnson], [produz as quatro fases do LO], [a quadratura é feita em hardware antes da placa de som],
    [Amplificadores I/Q], [condicionam Right/Left para ADC de áudio], [ganho e fase desiguais entre canais reduzem rejeição de imagem],
  )

  #v(0.25em)
  #text(size: 11.4pt)[A descrição do SDRZero destaca que ele é um receptor de conversão direta com dois canais em quadratura; o computador faz a demodulação e a escolha de banda lateral em software. Fonte: #link("https://wabicafe.com.br/py2sdr/SDRZero/SDRZero_1.php")[Descrição do Circuito em wabicafe.com.br].]
]

// ============================================================
// SLIDE 10 — SDRZero versus LimeSDR
// ============================================================
#slide[
  == Do SDRZero ao LimeSDR

  #set text(size: 13.8pt)

  #table(
    columns: (1.0fr, 1.75fr, 1.75fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Ideia*], [*No SDRZero*], [*No LimeSDR*]),
    [Sintonia], [LO discreto para uma faixa estreita], [PLL/RFIC programável por software],
    [Quadratura], [contador Johnson e chaves QSD visíveis], [misturadores I/Q e calibração dentro do chip],
    [Seleção de canal], [filtro de entrada analógico largo + áudio no PC], [largura de banda, ganho e taxa configuráveis],
    [Conversão A/D], [placa de som estéreo digitaliza I/Q], [ADCs rápidos integrados ao SDR],
    [Imperfeições], [ganho/fase I/Q, vazamento de LO e ruído ficam evidentes], [mesmos defeitos existem, mas são calibrados e transportados em alta taxa],
    [Papel do PC], [demodula áudio I/Q e rejeita imagem por DSP], [recebe amostras complexas já em banda base e roda receptor Wi-Fi ou outros protocolos],
  )

  #v(0.25em)
  #text(size: 12.5pt)[O SDRZero abre a caixa-preta do front-end; o LimeSDR mostra a mesma arquitetura em escala moderna, com integração, controle digital e requisitos de taxa muito maiores.]
]

// ============================================================
// SLIDE 11 — Por que Wi-Fi OFDM
// ============================================================
#slide[
  == Por que Wi-Fi usa OFDM?

  #set text(size: 16pt)
  #grid(
    columns: (1fr, 0.6fr),
    gutter: 1em,
    [
      Wi-Fi em ambiente interno sofre multi-caminho:

      - Reflexões em paredes, móveis e pessoas criam cópias atrasadas.
      - Em portadora única, um desvanecimento seletivo distorce todos os símbolos.
      - Em OFDM, cada subportadora vê um pedaço estreito do canal.
      - Algumas subportadoras caem em vales de cancelamento destrutivo.
      - Outras ficam em regiões de soma construtiva.
      - A equalização vira uma multiplicação complexa por subportadora.
      - Interleaving e FEC espalham os bits pelos tons.

      #v(0.25em)
      #text(size: 12.2pt)[Custo: FFT/IFFT, sensibilidade a erro de frequência e maior PAPR (_Peak-to-Average Power Ratio_).]
    ],
    [
      // Descrição para acessibilidade: fotografia de padrões de interferência óptica com três cores. No topo, as franjas vermelha, verde e azul aparecem sobrepostas; abaixo, cada cor aparece separadamente. O espaçamento das franjas depende da cor: azul tem franjas mais próximas, verde intermediárias e vermelho mais espaçadas. A imagem é usada como analogia visual: em um mesmo ponto, uma frequência pode estar em cancelamento destrutivo enquanto outra está em soma construtiva.
      #align(center)[
        #image("fig/double_slit_rgb_bill_alsept.jpg", width: 86%)
        #v(-0.35em)
        #text(size: 8pt)[Bill Alsept, Experimento de dupla de fenda de Young. \ Foto obtida de #link("https://physics.stackexchange.com/a/767606")[physics.stackexchange.com].]
      ]

      #v(0.15em)
      #set text(size: 12.4pt)
      Analogia visual: cada frequência cria seu próprio padrão de interferência.

      #v(0.15em)
      Onde uma cor cancela, outra pode somar. No rádio, multi-caminho cria vales em algumas frequências e preserva outras.
    ]
  )
]

// ============================================================
// SLIDE 12 — OFDM versus portadora única
// ============================================================
#slide[
  == OFDM versus portadora única

  #set text(size: 16pt)
  #grid(
    columns: (1fr, 1.2fr),
    gutter: 1em,
    [
      A diferença não é a constelação; é o mapeamento para forma de onda.

      - Portadora única: símbolos no tempo, depois _pulse shaping_.
      - OFDM: blocos de símbolos viram coeficientes de senoides ortogonais.
      - No transmissor: IFFT soma as subportadoras.
      - No receptor: FFT separa as subportadoras novamente.

      #v(0.4em)
      #text(size: 14pt)[Cada símbolo QAM fica difícil de ver no tempo, mas reaparece limpo no domínio da frequência.]
    ],
    [
      // Descrição para acessibilidade: This figure provides a visual comparison between a "Single Tone (Time Domain) Transmitter" and a "MultiTone (OFDM) Transmitter" through block diagrams and graphs. In the single-tone transmitter, incoming I[n] and Q[n] symbols enter "Waveform Mapping QAM Single Tone" and produce I(t) and Q(t); the waveform graph shows narrow pulse-shaped symbols labeled s1, s2, s3, s4; the magnitude spectrum is a single wide rectangular block centered at zero. In the OFDM transmitter, incoming I[n] and Q[n] symbols enter "Waveform Mapping OFDM" and produce I(t) and Q(t); the waveform graph shows overlapping longer sine-like waves; the magnitude spectrum shows multiple narrow overlapping subcarrier peaks, each carrying complex symbols such as -1+j, 1-j and 1+j.
      #align(center)[
        #image("fig/5-46.png", width: 100%)
        #v(-0.6em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 5-46: OFDM versus Pulse-Shape Mapping.]
      ]
    ]
  )
]

// ============================================================
// SLIDE 13 — Antes do OFDM: DSSS
// ============================================================
#slide[
  == Antes do OFDM: DSSS em 802.11b

  #set text(size: 16pt)
  #grid(
    columns: (0.86fr, 1.14fr),
    gutter: 1em,
    [
      Antes do Wi-Fi OFDM, 802.11b também precisava sobreviver a multi-caminho.

      - 1 e 2 Mb/s: DSSS com Barker de 11 chips.
      - O receptor correlaciona o sinal recebido com o código esperado.
      - Código alinhado: pico forte.
      - Ecos resolvíveis: picos atrasados.
      - Isso ajuda sincronismo e, em alguns receptores, combinação de caminhos.
      - 5,5 e 11 Mb/s: CCK, ainda baseado em chips/correlação, mas mais complexo.
      - OFDM venceu: equalização por tom, taxas altas, MIMO e OFDMA.
    ],
    [
      // Descrição para acessibilidade: dois gráficos explicam DSSS/Barker. O primeiro mostra a autocorrelação do código Barker de 11 chips, com um pico alto no atraso zero e lóbulos laterais pequenos. O segundo mostra a correlação de um sinal recebido com dois símbolos consecutivos, +Barker seguido de -Barker, caminho principal, ecos atrasados e ruído. A saída do correlator tem um pico positivo para +Barker, um pico negativo para -Barker, picos de ecos e um eco tardio do primeiro símbolo marcado como ISI por invadir a região do segundo símbolo. A legenda ressalta que DSSS/Barker usa correlação no tempo, enquanto OFDM usa equalização por subportadora.
      #align(center)[#image("fig/dsss_barker_multipath.svg", height: 4.45in)]
    ]
  )
]

// ============================================================
// SLIDE 14 — IFFT e FFT
// ============================================================
#slide[
  == IFFT/FFT: a transformação central

  #set text(size: 17pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      Para um bloco com $N$ subportadoras:

      $ x[n] = sum_(k=0)^(N-1) X[k] e^(j 2 pi n k / N) $

      $ X[k] = (1 / N) sum_(n=0)^(N-1) x[n] e^(-j 2 pi n k / N) $

      - $X[k]$: símbolo complexo colocado na subportadora `k`.
      - $x[n]$: amostras no tempo que serão transmitidas.
      - Ortogonalidade: a FFT mede a correlação contra cada tom.
    ],
    [
      // Descrição para acessibilidade: A system block diagram depicting the transmission path. On the modulator side, a Symbol Mapper provides symbols C0, C1, C2 into a serial-to-parallel shift register. The parallel data goes into an IFFT block, then through a shift register, an Insert GI block, and an Analog TX block to an antenna. In the middle, an OFDM symbol is shown as a short GI block followed by a longer IFFT Out block. On the demodulator side, a receiving antenna feeds Analog RX, Remove GI, shift register, FFT, shift register and Symbol Demapper, which outputs recovered symbols C0, C1, C2.
      #align(center)[
        #image("fig/5-52.png", width: 100%)
        #v(-0.6em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 5-52: Basic Modulation and Demodulation Process in OFDM.]
      ]
    ]
  )
]

// ============================================================
// SLIDE 15 — Prefixo cíclico
// ============================================================
#slide[
  == Prefixo cíclico: o truque do OFDM

  #set text(size: 13.8pt)
  #grid(
    columns: (0.88fr, 1.12fr),
    gutter: 1em,
    [
      O prefixo cíclico (CP) cria uma região segura para a janela da FFT.

      - O guard interval (GI) é uma cópia do fim do próprio símbolo útil.
      - A FFT pode começar um pouco dentro do GI.
      - Se "ecos cabem no GI", existe uma janela de `N` amostras sem pedaços do símbolo vizinho.
      - Dentro dessa janela, cada eco parece um deslocamento circular do mesmo símbolo.

      #v(0.15em)
      #rect(
        width: 100%,
        inset: 5pt,
        radius: 4pt,
        fill: rgb("#eff6ff"),
        stroke: 0.7pt + rgb("#60a5fa"),
      )[
        #text(weight: "bold", fill: rgb("#1d4ed8"))[Ideia-chave:] \ deslocamento no tempo $arrow.r$ fase na frequência.\
        #text(size: 11.8pt)[A soma dos ecos vira $H[k]$: $quad Y[k] = H[k] X[k] + N[k]$.]
      ]

      #v(0.15em)
      #text(size: 11.7pt)[Em 802.11a/g: útil de 3,2 µs + GI de 0,8 µs = 4 µs. Começar cedo reduz o risco de pegar o próximo símbolo.]
    ],
    [
      // Descrição para acessibilidade: diagrama temporal do prefixo cíclico. No topo aparece um símbolo OFDM transmitido com um símbolo anterior, o intervalo de guarda GI, o símbolo útil de N amostras e o próximo símbolo. O GI é marcado como cópia do fim do símbolo útil. Abaixo, três linhas mostram o caminho direto e dois ecos atrasados, todos ainda pertencendo ao mesmo símbolo estendido. Na parte inferior, uma faixa verde indica a região válida para iniciar a janela FFT; regiões vermelhas indicam início cedo demais, com símbolo anterior, e tarde demais, com próximo símbolo. Uma janela FFT de N amostras começa um pouco dentro do GI. A legenda explica que, se os ecos cabem no GI, existe uma faixa de inícios de FFT sem ISI e os ecos viram deslocamentos circulares.
      #align(center)[#image("fig/cyclic_prefix_window.svg", width: 100%)]
    ]
  )
]

// ============================================================
// SLIDE 16 — Prefixo cíclico como convolução circular
// ============================================================
#slide[
  == Por que o prefixo precisa ser cíclico?

  #set text(size: 13pt)

  O objetivo do GI é fazer o multipercurso curto parecer uma convolução circular dentro da janela FFT.

  #let panel-sep = align(center + horizon)[
    #line(length: 3.55in, angle: 90deg, stroke: 0.55pt + rgb("#cbd5e1"))
  ]

  #grid(
    columns: (1fr, 0.55pt, 1fr, 0.55pt, 1fr),
    gutter: 0.65em,
    [
      *No tempo: eco de 1 amostra*

      $x = [a,b,c,d]$, $h = [1,alpha]$

      #rect(
        width: 100%,
        inset: 6pt,
        radius: 4pt,
        fill: rgb("#ecfdf5"),
        stroke: 0.7pt + rgb("#34d399"),
      )[
        #text(weight: "bold", fill: rgb("#047857"))[CP correto:] `[d | a b c d]` \
        eco atrasado na janela: `[d a b c]`

        #align(center)[
          $y = [a + alpha d, b + alpha a, c + alpha b, d + alpha c]$
        ]

        #align(center)[$y[n] = x[n] + alpha x[(n - 1) mod 4]$]
      ]

      #v(0.65em)
      #rect(
        width: 100%,
        inset: 6pt,
        radius: 4pt,
        fill: rgb("#fff7ed"),
        stroke: 0.7pt + rgb("#fb923c"),
      )[
        #text(weight: "bold", fill: rgb("#c2410c"))[CP errado:] `[a | a b c d]`

        Primeira amostra: $a + #text(fill: rgb("#dc2626"))[$alpha a$]$. \
        A circular correta exigia $a + alpha d$.
      ]
    ],
    panel-sep,
    [
      *Na frequência: multiplicação por tom*

      Convolução circular:

      #align(center)[$y[n] = sum_l h[l] x[(n - l) mod N]$]

      Após a FFT:

      #align(center)[
        $Y[k] = H[k] X[k]$ \
        $H[k] = sum_l h[l] e^(-j 2 pi l k / N)$
      ]
    ],
    panel-sep,
    [
      *Exemplo numérico*

      CP correto, só subportadora $k = 2$:

      #rect(
        width: 100%,
        inset: 6pt,
        radius: 4pt,
        fill: rgb("#ecfdf5"),
        stroke: 0.7pt + rgb("#34d399"),
      )[
        #align(center)[
          $x = [1,-1,1,-1]$, $X = [0,0,1,0]$ \
          $h = [1,0.5]$ \
          $H[2] = 1 + 0.5 e^(-j pi) = 0.5$ \
          $Y = [0,0,0.5,0]$
        ]
      ]

      #v(0.65em)
      CP errado: `[1 | 1 -1 1 -1]`

      #rect(
        width: 100%,
        inset: 6pt,
        radius: 4pt,
        fill: rgb("#fff7ed"),
        stroke: 0.7pt + rgb("#fb923c"),
      )[
        #align(center)[
          $y_"err" = [1.5,-0.5,0.5,-0.5]$ \
          $Y_"err" = [#text(fill: rgb("#dc2626"))[$0.25$], #text(fill: rgb("#dc2626"))[$0.25$], 0.75, #text(fill: rgb("#dc2626"))[$0.25$]]$
        ]
      ]

      A energia vazou para outros bins.
    ],
  )

  #v(1em)
  Sem CP correto, a FFT ainda calcula uma DFT; o que se perde é o modelo simples de um ganho independente por subportadora.
]

// ============================================================
// SLIDE 17 — OFDM 802.11a/g
// ============================================================
#slide[
  == OFDM em 802.11a/g

  // Descrição para acessibilidade: A stem plot showing the arrangement of tones across the frequency band. The center tone 0 is empty. The negative side has tones from -1 to -26, with tones -7 and -21 marked as pilot tones and tone -26 marking -8.125MHz. The positive side has tones from 1 to 26, with tones 7 and 21 marked as pilot tones and tone 26 marking 8.125MHz. Spacing is indicated as 312.5KHz between tones. The frequency span beyond plus or minus 26 is empty.
  #align(center)[
    #image("fig/7-15.png", width: 90%)
    #v(-0.6em)
    #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 7-15: Distribution of Information Carrying and Pilot Tones.]
  ]

  #set text(size: 13.5pt)
  Parâmetros principais:

  #table(
    columns: (1.05fr, 1.3fr, 2.1fr),
    inset: 4pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Item*], [*Valor*], [*Função*]),
    [Taxa de amostragem], [20 MS/s], [64 amostras em 3,2 µs],
    [FFT/IFFT], [64 pontos], [subportadoras espaçadas de 312,5 kHz],
    [Subportadoras úteis], [52], [48 dados + 4 pilotos],
    [Pilotos], [-21, -7, 7, 21], [rastrear fase e temporização],
    [Nulas], [DC e bordas], [evitar DC e criar guarda espectral],
  )
]

// ============================================================
// SLIDE 18 — Taxas Wi-Fi
// ============================================================
#slide[
  == Taxas 802.11a/g: bits por símbolo OFDM

  #set text(size: 12.2pt)

  #table(
    columns: (0.65fr, 0.95fr, 0.85fr, 0.9fr, 0.9fr),
    inset: 6pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Mbps*], [*Modulação*], [*Código*], [*$N_("CBPS")$*], [*$N_("DBPS")$*]),
    [6], [BPSK], [1/2], [48], [24],
    [9], [BPSK], [3/4], [48], [36],
    [12], [QPSK], [1/2], [96], [48],
    [18], [QPSK], [3/4], [96], [72],
    [24], [16-QAM], [1/2], [192], [96],
    [36], [16-QAM], [3/4], [192], [144],
    [48], [64-QAM], [2/3], [288], [192],
    [54], [64-QAM], [3/4], [288], [216],
  )

  #v(0.3em)
  #set text(size: 13.8pt)
  - A prática usa QPSK 1/2 no testbench: simples para ser fácil de depurar e ainda contém FEC.
  #v(0.3em)
  - Taxas maiores combinam _puncturing_ com LLRs mais elaborados para 16/64-QAM.
    - _Puncturing_: transmitir só parte dos bits codificados para obter taxa 2/3 ou 3/4.
    - LLR (_Log-Likelihood Ratio_): $log(P(b=1 | y) / P(b=0 | y))$; sinal indica o bit mais provável, módulo indica confiança.
]

// ============================================================
// SLIDE 19 — Estrutura do pacote
// ============================================================
#slide[
  == Estrutura do pacote 802.11a/g

  #set text(size: 15.5pt)

  // Descrição para acessibilidade: A horizontal timing timeline mapping out the structure of a standard packet. The preamble is 16 microseconds total: a Short Training Sequence of 8 microseconds broken into ten small segments t1 through t10, and a Long Training Sequence of 8 microseconds broken into guard interval GI2 and two long segments T and T. The payload has a variable length. The SIGNAL field is 4 microseconds, made of GI followed by Signal data, labeled Rate/Length and acting as the first payload symbol. DATA symbols repeat the same 4 microsecond structure, GI followed by Data.
  #align(center)[
    #image("fig/7-14.png", width: 85%)
    #v(-1em)
    #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 7-14: WLAN 802.11a Packet Structure.]
  ]

  O preâmbulo é o manual de instruções do receptor:

  - `STS` (_Short Training Sequence_): AGC, detecção de pacote e CFO grosseiro.
  - `LTS` (_Long Training Sequence_): CFO fino, referência de tempo e canal.
  - `SIGNAL`: taxa e comprimento, sempre BPSK 1/2.
  - `DATA`: serviço, PSDU, cauda, padding; modulação depende da taxa.

  #v(0.4em)
  #text(size: 14pt)[Sem preâmbulo, a FFT não saberia onde começar nem como desfazer o canal.]
]

// ============================================================
// SLIDE 20 — Campo SIGNAL
// ============================================================
#slide[
  == Campo SIGNAL: o cabeçalho físico

  #set text(size: 16pt)

  `create_signal_field()` gera 24 bits antes da codificação:

  - `RATE`: 4 bits que indicam modulação e taxa de código.
  - `Reserved`: 1 bit fixo em zero.
  - `LENGTH`: 12 bits com o tamanho do PSDU em bytes.
  - `Parity`: paridade par dos primeiros 17 bits.
  - `TAIL`: 6 zeros para terminar o codificador no estado zero.

  Depois:

  - codificação convolucional taxa 1/2 transforma 24 em 48 bits;
  - interleaving BPSK reorganiza esses 48 bits;
  - mapeamento BPSK coloca um bit por subportadora de dados;
  - insere 48 símbolos BPSK e 4 pilotos na IFFT;
  - adiciona GI/CP de 16 amostras: `SIGNAL` dura 4 µs.
]

// ============================================================
// SLIDE 21 — DATA no transmissor
// ============================================================
#slide[
  == Campo DATA no transmissor

  #set text(size: 15.5pt)

  O `SIGNAL` não é embaralhado; o scrambler começa no campo `DATA`.

  `encode_data_field()` monta a carga útil física:

  - `SERVICE`: 16 zeros; os primeiros bits ajudam a recuperar o estado do scrambler.
  - `PSDU`: quadro MAC mais CRC32.
  - `TAIL`: 6 zeros para forçar estado final conhecido no Viterbi.
  - `PAD`: completa o último símbolo OFDM.

  Em seguida, para cada símbolo OFDM de DATA:

  - embaralha $N_("DBPS")$ bits de dados;
  - codificação e puncturing geram $N_("CBPS")$ bits codificados;
  - interleaving reorganiza esses $N_("CBPS")$ bits;
  - mapeamento coloca símbolos de constelação nas 48 subportadoras de dados;
  - insere 48 símbolos de dados e 4 pilotos na IFFT;
  - adiciona GI/CP de 16 amostras: cada símbolo DATA dura 4 µs.
]

// ============================================================
// SLIDE 22 — Modelo de defeitos
// ============================================================
#slide[
  == O sinal chega machucado

  #set text(size: 18pt)
  #grid(
    columns: (0.8fr, 1fr),
    gutter: 1em,
    [
      Defeitos injetados pela prática e discutidos a seguir:

      - `ThermalNoise`: AWGN complexo.
      - `Multipath`: filtro FIR complexo com perfil de atraso.
      - `Freq_Offset`: rotação linear acumulada.
      - `PhaseNoise`: rotação de fase variante no tempo.
      - `IQ_Imbalance`: ganho desigual e erro de quadratura entre I/Q.
      - `TimingOffset` e `TimingDrift`: erro estático e deriva de amostragem.
    ],
    [
      // Descrição para acessibilidade: A block diagram showing a pipeline of defects applied sequentially to a signal. The input is TX Waveform Mapping with Sample Rate noted below. It flows into Multipath Linear Distortion, then Thermal Noise, then Phase Noise, then Frequency Offset, then IQ Imbalance, then Timing Offset and Drift. Each block lists a relevant parameter such as delay spread, noise variance, phase noise profile, frequency offset, phase imbalance, time and drift. The output is RX Waveform Synchronization.
      #align(center)[
        #image("fig/6-16.png", width: 100%)
        #v(-1em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 6-16: Overview of the Defect Models and Order of Insertion.]
      ]

      // Descrição para acessibilidade: A block diagram of an RF Zero-IF Receiver highlighting defect sources: multipath and thermal AWGN before the RX antenna, nonlinear distortion in LNA/VGA, phase noise, frequency offset and IQ imbalance at the IQ synthesizer, DC offsets after low-pass filters and timing error/timing drift at ADC sampling clocks.
      #align(center)[
        #image("fig/6-3.png", width: 100%)
        #v(-1em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 6-3: Distortion, Offset and Noise Sources in a Zero-IF Receiver.]
      ]
    ]
  )
]

// ============================================================
// SLIDE 23 — Ruído térmico e EVM
// ============================================================
#slide[
  == Ruído térmico: o defeito que não se corrige

  #set text(size: 16pt)
  #grid(
    columns: (2.2fr, 1fr),
    gutter: 1em,
    [
      Ruído térmico adiciona uma componente aleatória: $r = s + w$.

      - Abaixo do SNR necessário, não há algoritmo que recupere a informação: limite de Shannon-Hartley.
      - O receptor melhora a decisão preservando confiança: _soft bits_ e FEC.
      - Em OFDM, ruído aparece em todas as subportadoras após a FFT.
      - EVM (_Error Vector Magnitude_) mede a distância média entre símbolos corrigidos e pontos ideais; em dB, mais negativo é melhor.

      #v(0.4em)
      #text(size: 14pt)[Correção em 802.11: não "remove" AWGN; estima canal, evita degradar mais e usa FEC: BCC/Viterbi em 802.11a/g, LDPC nas normas posteriores.]
    ],
    [
      // Descrição para acessibilidade: A Cartesian coordinate graph representing the complex IQ plane with I on the horizontal axis and Q on the vertical axis. Four ideal reference points form a square at [1,1], [-1,1], [-1,-1] and [1,-1]. In the upper right quadrant, an actual received point P is plotted slightly down and left of the ideal [1,1] point. An arrow labeled Error Vector points from the received symbol P to the ideal reference point.
      #align(center)[
        #image("fig/6-6.png", width: 100%)
        #v(-0.6em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 6-6: Error Vector in a QPSK Constellation.]
      ]
    ]
  )
]

// ============================================================
// SLIDE 24 — Multi-caminho
// ============================================================
#slide[
  == Multi-caminho: canal como FIR

  #set text(size: 14pt)

  // Descrição para acessibilidade: A diagram showing the equivalence between physical multipath and a discrete transversal FIR filter. On the left, a TX antenna transmits x[n], which bounces off an obstacle and arrives at an RX antenna through multiple delayed paths labeled h[0] x[n], h[1] x[n-1], h[3] x[n-3] and h[2] x[n-2]. On the right, x[n] flows through delay blocks D; taps x[n], x[n-1], x[n-2] and later delayed samples are multiplied by complex coefficients h[0], h[1], h[2] and so on, and all products are summed to produce y[n].
  #align(center)[
    #image("fig/6-19.png", width: 60%)
    #v(-1em)
    #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 6-19: Transversal Filter Model of Linear Distortion.]
  ]

  Modelo discreto:

  $ y[n] = sum_l h[l] x[n-l] + w[n] $

  - Cada eco tem atraso, amplitude e fase.
  - No tempo: ecos podem causar sobreposição entre símbolos.
  - Na frequência: a soma cria vales e picos em $H[k]$.
  - OFDM separa o problema em subportadoras estreitas.

  #v(0.4em)
  #text(size: 14pt)[Correção em 802.11: GI/CP evita ISI se os ecos cabem nele; LTS estima $H[k]$; equalizador multiplica por $1\/H[k]$.]
]

// ============================================================
// SLIDE 25 — Fading seletivo
// ============================================================
#slide[
  == Fading seletivo e EVM por subportadora


  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      // Descrição para acessibilidade: A frequency response graph plotting magnitude in dB from -25 to 0 against frequency from -2e7 to 2e7 Hz. The solid line for 100 nanosecond delay spread shows deep, sharp nulls dipping below -15 dB or -20 dB at multiple frequencies. The dashed line with open circles for 25 nanosecond delay spread is smoother, with only shallow dips and much less frequency selectivity.
      #align(center)[
        #image("fig/6-21.png", width: 86%)
        #v(-1em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 6-21: Magnitude Response of Channels with 100nsec and 25nsec RMS Delay Spread.]
      ]
    ],
    [
      // Descrição para acessibilidade: A 2x2 grid for 100 ns delay spread. EVM versus frequency has severe variation, reaching poor values near -10 dB in narrow bands and good values near -28 dB in others. The multipath magnitude response has multiple deep fading notches, and each notch corresponds to a large EVM spike. EVM versus time is worse, around -20 dB, and FIR taps show energy spread across many taps.
      #align(center)[
        #image("fig/7-58.png", width: 86%)
        #v(-1em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 7-58: Performance Graphs for SNR = 25dB and Multipath Delay Spread of 100 Nanoseconds.]
      ]
    ]
  )

  #v(-0.7em)
  #set text(size: 13pt)
  Leitura prática dos gráficos:

  - À esquerda: maior delay spread cria vales mais profundos em $H[k]$.
  - Zero-forcing por $1\/H[k]$: vale profundo amplifica ruído.
  #v(0.2em)
  - À direita: EVM vs frequência ruim em tons específicos indica desvanecimento seletivo ou erro de equalização.
  - À direita: se EVM vs tempo piorasse ao longo do pacote, sugeriria rastreamento de fase/temporização ruim.
  - Interleaving + FEC espalham erros concentrados em poucos tons.
]

// ============================================================
// SLIDE 26 — Offset de frequência
// ============================================================
#slide[
  == CFO: erro de frequência de portadora

  #set text(size: 18pt)

  CFO (_Carrier Frequency Offset_) vem de osciladores diferentes:

  - Em 2,4 GHz, erro de 20 ppm dá 48 kHz em cada rádio.
  - TX e RX em extremos opostos podem produzir quase 100 kHz de erro relativo.
  - Em OFDM, CFO desloca subportadoras e quebra ortogonalidade.
  - No tempo discreto, aparece como multiplicação por $e^(j 2 pi Delta f n / F_s)$.
  - Depois da correção inicial, o resíduo aparece como fase comum por símbolo.

  Correção em 802.11:

  - STS estima CFO grosseiro com período de 16 amostras.
  - LTS estima CFO fino com período de 64 amostras.
  - NCO digital multiplica pelo tom oposto para cancelar a rotação.
]

// ============================================================
// SLIDE 27 — Ruído de fase
// ============================================================
#slide[
  == Ruído de fase e resíduo de CFO

  #set text(size: 18pt)

  Mesmo depois da correção de frequência, sobra rotação lenta:

  - CFO residual: fase acumula símbolo a símbolo.
  - Ruído de fase de baixa frequência: rotação comum quase constante dentro de um símbolo.
  - Ruído de fase rápido: muda dentro da janela FFT e causa ICI (_Inter-Carrier Interference_), que os pilotos não removem bem.

  Correção em 802.11:

  - pilotos conhecidos em cada símbolo medem fase comum;
  - todos os tons são multiplicados por $e^(-j theta)$;
  - equalizador pode ser atualizado lentamente para rastrear deriva;
  - ICI rápido fica como degradação residual de EVM/SNR.
]

// ============================================================
// SLIDE 28 — I/Q, DC e não linearidade
// ============================================================
#slide[
  == Defeitos de RF fora do fluxo OFDM didático

  #set text(size: 18pt)

  Eles chegam no vetor I/Q antes da cadeia OFDM:

  - *Desequilíbrio I/Q*: ganho/fase diferentes entre I e Q; cria imagem conjugada. A prática modela, mas não corrige.
  - *Offset DC*: vazamento de LO e offsets analógicos; aparece em DC. Hardware/driver pode remover antes.
  - *Não linearidade*: compressão/clipping em LNA, mixer, VGA/ADC ou PA do TX; AGC evita, mas não desfaz.

  Em uma implementação real:

  - RFIC/driver pode calibrar I/Q e remover DC antes do script;
  - planejamento de ganho evita saturação;
  - o receptor didático foca em CFO, janela FFT, equalização, pilotos e FEC.
]

// ============================================================
// SLIDE 29 — Temporização
// ============================================================
#slide[
  == Erro e deriva de temporização

  #set text(size: 17pt)

  Temporização tem duas escalas:

  - *Aquisição*: escolher a primeira janela FFT correta.
  - *Rastreamento*: compensar deriva entre relógios de TX e RX ao longo do pacote.

  Efeitos:

  - se a janela começa fora da região segura, há ISI;
  - se há pequeno deslocamento dentro do prefixo, aparece rampa de fase vs. subportadora;
  - se a deriva acumula muito, só corrigir fase pós-FFT deixa de bastar.

  Correção em 802.11:

  - LTS por correlação define o início da FFT;
  - pilotos medem a inclinação de fase por subportadora;
  - receptor aplica rampa por tom e atualiza o equalizador;
  - em sistemas completos, também ajusta um interpolador.
]

// ============================================================
// SLIDE 30 — Tabela impairment -> correção
// ============================================================
#slide[
  == Defeitos: corrigir pela assinatura

  #set text(size: 10.3pt)

  #table(
    columns: (1.50fr, 1.30fr, 1.2fr, 1.70fr),
    inset: 4pt,
    stroke: 0.45pt,
    align: horizon,
    table.header([*Assinatura observável*], [*Causas que caem nela*], [*Medição*], [*Correção no receptor*]),
    [Rotação amostra a amostra; ICI se grande], [CFO inicial entre TX e RX], [autocorrelação STS/LTS], [NCO digital antes da FFT],
    [Fase comum por símbolo], [CFO residual, fase inicial, ruído de fase lento], [fase média dos pilotos], [derrotação $e^(-j theta)$ em todos os tons],
    [Rampa de fase vs. tom], [timing offset residual, timing drift/SFO], [inclinação dos pilotos], [correção linear por subportadora; atualização lenta],
    [Canal linear estável $H[k]$], [multipercurso dentro do CP, filtros, ganho/atraso fixo], [LTS conhecida], [GI + FFT + equalizador $1 \/ H[k]$],
    [Janela fora da região segura], [timing ruim, ecos além do CP], [correlação LTS, ISI/EVM], [`sample_advance`; se excede GI, não há correção simples],
    [Ruído/interferência residual], [AWGN, quantização, ICI residual], [EVM/SNR/LLR], [LLR + interleaving + FEC; não remove deterministicamente],
    [Componente em DC], [vazamento de LO, offsets de mixer/amp/ADC], [média, tom DC], [DC block, subtração de média, tom DC nulo],
    [Imagem conjugada], [desequilíbrio I/Q de ganho/fase], [imagem, elipse, ganho/fase I/Q], [calibração/compensação I/Q fora do fluxo didático],
  )

  #v(0.25em)
  #text(size: 9.6pt)[A mesma correção pode servir para causas físicas diferentes quando a assinatura observável é a mesma.]
]

// ============================================================
// SLIDE 31 — Transformações no código
// ============================================================
#slide[
  == Transformações no código da prática

  #set text(size: 11.5pt)

  #table(
    columns: (1.25fr, 0.72fr, 1.25fr, 2.1fr),
    inset: 4pt,
    stroke: 0.45pt,
    align: horizon,
    table.header([*Como chega*], [*Bloco*], [*Como fica*], [*Por que funciona / por que precisa*]),
    [amostras I/Q cruas], [detector], [início marcado], [STS repetida faz a autocorrelação subir],
    [pacote com CFO], [corrige CFO], [CFO inicial reduzido], [fase entre repetições estima erro de frequência],
    [tempo sem janela], [LTS], [janela FFT posicionada], [sequência conhecida indica onde o símbolo útil começa],
    [64 amostras no tempo], [FFT], [64 tons complexos], [OFDM transforma eco em ganho por subportadora],
    [tons afetados por $H[k]$], [equaliza], [tons equalizados], [LTS estima $H[k]$; aplica ganho inverso],
    [fase comum residual], [pilotos: $theta$], [rotação corrigida], [pilotos medem intercepto de fase por símbolo],
    [rampa residual], [pilotos: slope], [timing rastreado], [pilotos medem inclinação de fase vs. tom],
    [64 tons com guardas/pilotos], [extrai dados], [48 símbolos de dados], [802.11 define quais tons carregam carga útil],
    [símbolos QAM/PSK], [demapper], [LLRs por bit], [distância à constelação vira confiança],
    [LLRs interleavados], [deinterleaver], [LLRs do codificador], [desfaz permutação que espalha erros em rajada],
    [LLRs codificados], [Viterbi], [bits estimados], [treliça escolhe caminho de maior métrica],
    [bits embaralhados], [descrambler], [`SERVICE + PSDU + TAIL`], [LFSR desfaz whitening do transmissor],
    [bits do PSDU], [pack + CRC], [bytes validados], [CRC confirma plausibilidade do quadro],
  )
]

// ============================================================
// SLIDE 32 — Entrada de amostras
// ============================================================
#slide[
  == Como o sinal chega ao Python

  #set text(size: 15.2pt)

  // Descrição para acessibilidade: diagrama com três linhas horizontais que convergem para o mesmo vetor `rx_waveform_20mhz`. A linha `--testbench` passa por transmissor sintético, canal com AWGN, CFO e multipercurso, decimação para 20 MS/s e um vetor complex64. A linha `--npz` passa por arquivo NPZ com trechos I/Q já recortados, seleção de vetor e complex64. A linha `--iq` passa por arquivo I/Q contínuo capturado por SDR, detector simples por limiar de magnitude, recorte de candidato e complex64. As três setas se juntam em `rx_waveform_20mhz`, descrito como vetor complexo a 20 MS/s, que é o contrato comum para o packet detector e os demais blocos do receptor.
  #align(center)[#image("fig/python_inputs.svg", width: 96%)]
  #v(-0.45em)

  #text(size: 12.8pt)[`rx_waveform_20mhz`: vetor `complex64` a 20 MS/s, com ruído, talvez um pacote, CFO, multi-caminho, fase e timing imperfeitos. A referência inicial ainda é nenhuma: a primeira tarefa é descobrir se existe um pacote válido e onde ele começa.]

  #v(0.15em)
  #text(size: 12.8pt)[No `--testbench`, o TX/canal rodam a 40 MS/s para aplicar defeitos em uma grade 2x mais fina: taps e timing podem cair em meia amostra do receptor. Depois a decimação entrega o mesmo contrato dos arquivos reais: 20 MS/s.]
]

// ============================================================
// SLIDE 33 — Packet detector
// ============================================================
#slide[
  == `packet_detector`: achar a STS

  #set text(size: 14pt)

  // Descrição para acessibilidade: A signal flowchart illustrating the packet detection algorithm. Input x[n] splits into two paths. The upper path delays x[n] by 16 samples, conjugates it, multiplies by the current x[n], applies a sliding average of length N and then an absolute value to produce an autocorrelation estimate. The lower path multiplies x[n] by its own conjugate and applies a sliding average to produce a variance estimate. The absolute autocorrelation and variance enter a comparison ratio block and a threshold detector, producing a binary packet detection flag.
  #align(center)[
    #image("fig/7-40.png", width: 85%)
    #v(-1em)
    #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 7-40: 802.11a Packet Detector.]
  ]

  STS no preâmbulo: 10 repetições de 16 amostras (`t1` a `t10`), total de 8 µs.

  Como chega: amostras I/Q sem referência de início.

  #grid(
    columns: (1fr, 1.2fr),
    gutter: 1em,
    [
      Como fica:

      - `comparison_ratio[n] = |R_16[n]| / P[n]`;
      - `packet_det_flag[n]` com histerese;
      - `falling_edge_position`: fim aproximado da STS.
    ],
    [
      Por que funciona:

      - STS repete a cada 16 amostras;
      - ruído/interferência não tem essa periodicidade;
      - CFO muda apenas fase; multi-caminho preserva a repetição;
      - normalização por potência evita depender do ganho absoluto.
    ]
  )
]

// ============================================================
// SLIDE 34 — Histerese do detector
// ============================================================
#slide[
  == Detecção: razão, platô e borda

  #set text(size: 15.5pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      A prática pede um detector robusto, não um pico isolado.

      Durante a STS, a periodicidade de 16 amostras dura várias repetições; por isso a razão de autocorrelação forma um platô.

      - limiar alto, por exemplo 0,85, liga a detecção;
      - limiar baixo, por exemplo 0,65, desliga a detecção;
      - a borda de descida marca a transição `STS -> LTS`.

      A borda de subida depende de energia, AGC e limiar; a descida fica mais próxima da mudança estrutural do preâmbulo.

      #v(0.4em)
      #text(size: 14pt)[`falling_edge_position` agenda CFO, LTS e janelas de busca.]
    ],
    [
      // Descrição para acessibilidade: Two synchronized time-domain graphs. The top graph is a binary packet detection flag that stays at 0, jumps to 1 during the preamble plateau, then drops back to 0. The bottom graph is the comparison ratio: before the packet it fluctuates as noisy low values, during the short preamble it ramps to a flat plateau just below 1, and after the preamble it falls back to noisy low values. The flag is triggered by the ratio crossing a high threshold.
      #align(center)[
        #image("fig/7-42.png", width: 100%)
        #v(-0.6em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 7-42: Comparison Result as Autocorrelation Estimate/Variance.]
      ]
    ]
  )
]

// ============================================================
// SLIDE 35 — CFO detection
// ============================================================
#slide[
  == `detect_frequency_offsets`: fase vira Hz

  #set text(size: 13.8pt)
  #grid(
    columns: (1.2fr, 1fr),
    gutter: 1em,
    [
      Se uma sequência repete após `P` amostras:

      $ r[n] = a[n] e^(j 2 pi Delta f n / F_s), quad a[n] = a[n-P] $

      $ r[n] r^*[n-P] = |a[n]|^2 e^(j 2 pi Delta f P / F_s) $

      O produto com conjugado remove a sequência repetida; sobra a rotação acumulada:

      $ theta = 2 pi Delta f P / F_s $

      $ Delta f = theta F_s / (2 pi P) $

      - STS: `P = 16`, faixa de captura maior, precisão menor.
      - LTS: `P = 64`, faixa menor, precisão maior.
      - O código mede a fase da autocorrelação em posições agendadas pelo detector.
    ],
    [
      // Descrição para acessibilidade: Two circle diagrams illustrating the mapping between phase angles and frequency. The left coarse frequency map uses a circle from -pi to pi and shows a generic angle theta_short; below it, FrequencyOffset_coarse = theta_short times 20e6 Hz divided by 2 pi times 16. The right fine frequency map is similar but uses theta_long and divides by 64, giving a tighter, more precise frequency map.
      #align(center)[
        #image("fig/7-43.png", width: 100%)
        #v(-1em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 7-43: Correlation Output to Frequency Offset Conversion.]
      ]
      // Descrição para acessibilidade: Two signal flow block diagrams. The coarse detector delays x[n] by 16 samples, conjugates, multiplies by x[n], sliding-averages and applies atan2 to output theta_short. The fine detector is identical except the delay is 64 samples and outputs theta_long.
      #align(center)[
        #image("fig/7-44.png", width: 100%)
        #v(-1em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 7-44: Coarse and Fine Frequency Detectors.]
      ]
    ]
  )
]

// ============================================================
// SLIDE 36 — Correção por NCO
// ============================================================
#slide[
  == Corrigir CFO: multiplicar por um NCO

  #set text(size: 16pt)

  Como chega:

  - amostras girando no plano complexo por CFO;
  - constelação futura giraria símbolo a símbolo;
  - FFT sofreria perda de ortogonalidade.

  Transformação no código:

  ```python
  n = np.arange(len(rx_waveform_20mhz))
  nco = np.exp(-1j * 2*np.pi * n * offset / 20e6)  # calcula um valor do NCO para cada amostra
  rx_waveform_20mhz *= nco  # multiplica amostra a amostra, in-place
  ```

  Por que funciona:

  - deslocamento em frequência é multiplicação por exponencial complexa;
  - multiplicar pela exponencial oposta traz a portadora para zero.
]

// ============================================================
// SLIDE 37 — LTS correlator
// ============================================================
#slide[
  == `long_symbol_correlator`: achar a janela FFT

  #set text(size: 15pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      Como chega: CFO já reduzido; início da FFT ainda incerto.

      A LTS no preâmbulo é:

      `GI2` (32 amostras) + `T1` (64) + `T2` (64).

      O correlacionador desliza uma LTS local de 64 amostras e gera `output_long[n]`.
      O pico `lt_peak_position` dá o alinhamento da LTS.

      No código:

      - pico bruto $approx$ fim de `T1`, fronteira `T1`/`T2`;
      - `p = lt_peak_position - sample_advance`;
      - canal: `T1 = rx[p-64:p]`, `T2 = rx[p:p+64]`;
      - 1ª FFT pós-preâmbulo: `rx[p+64+16:p+64+16+64]`.
    ],
    [
      // Descrição para acessibilidade: A block diagram illustrating a sliding cross-correlator using a transversal filter. The input x[n] enters a series of delay blocks z^-1, producing x[n], x[n-1] and so on to x[n-63]. Each delayed tap is multiplied by a conjugated coefficient from the long training sequence in reverse order, such as L[63]^*, L[62]^* and L[0]^*. All products are summed to yield Output[n].
      #align(center)[
        #image("fig/7-45.png", width: 100%)
        #v(-1em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 7-45: Sliding Cross-correlator Implementation for Long Training Sequence.]
      ]
      // Descrição para acessibilidade: A line graph plotting magnitude output of the cross-correlator over discrete time from 200 to 950. The noisy floor stays below 200. Three distinct sharp spikes appear: one near 440 with lower amplitude for guard interval correlation, a highest spike near 500 for the first long training symbol, and another high spike near 570 for the second long training symbol.
      #align(center)[
        #image("fig/7-46.png", width: 100%)
        #v(-1em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 7-46: Output of Long Training Symbol Cross-correlator.]
      ]
    ]
  )
]

// ============================================================
// SLIDE 38 — Sample advance
// ============================================================
#slide[
  == `sample_advance`: não mirar no limite

  #set text(size: 15pt)

  // Descrição para acessibilidade: A timing diagram illustrating overlap of OFDM symbols due to multipath and identifying the ideal FFT window. The strongest path timeline shows Previous IFFT Output, GI, Current IFFT Output, GI and Next IFFT Output. A post-cursor of the previous symbol arrives late and bleeds into the current GI but stops before the useful symbol. A pre-cursor of the next OFDM symbol arrives early and bleeds backward near the end of the current IFFT output. A bracketed Preferred Range for FFT Calculation is shifted slightly left, starting inside the safe portion of the GI and ending before next-symbol pre-cursor interference.
  #align(center)[
    #image("fig/7-47.png", width: 90%)
    #v(-1em)
    #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 7-47: The Preferred Range for the FFT Calculation.]
  ]

  A melhor janela FFT não é necessariamente o pico exato do caminho mais forte.

  - Começar cedo demais: pode pegar pós-cursor do símbolo anterior.
  - Começar tarde demais: pode pegar pré-cursor do próximo símbolo.
  - Começar um pouco dentro do GI: ainda é uma cópia cíclica válida.
  - O deslocamento temporal vira rampa de fase, que o equalizador consegue absorver.
]

// ============================================================
// SLIDE 39 — Estimação de canal
// ============================================================
#slide[
  == Estimar o canal com a LTS

  #set text(size: 15pt)
  #grid(
    columns: (1fr, 1.3fr),
    gutter: 1em,
    [
      Na LTS, o transmissor enviou tons conhecidos `Ideal_Tones[k]`.

      No receptor:

      - extrai duas LTS de 64 amostras;
      - faz média para reduzir ruído;
      - aplica FFT;
      - estima $H[k] = "RX"[k] / "Ideal"[k]$;
      - define coeficientes $E[k] = 1 / H[k]$.

      #v(0.4em)
      #text(size: 14pt)[Como fica: vetor de 64 coeficientes complexos, com tons nulos protegidos contra divisão por zero.]
    ],
    [
      // Descrição para acessibilidade: A block diagram detailing channel estimation and equalization. The data path sends input x[n] into a shift register and FFT. Uncorrected subcarriers pass into an equalization multiplication node and become equalized symbols for pilot tone processing. During the preamble, the FFT output for the long symbol is RX_Tones[m]. A ROM supplies Ideal_Tones[m]. A divider computes Ideal_Tones[m] divided by RX_Tones[m] to produce equalizer coefficients, which are stored and applied to subsequent payload symbols. Timing reference and state machine coordinate the blocks.
      #align(center)[
        #image("fig/7-48.png", width: 100%)
        #v(-0.6em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 7-48: Equalizer Positioning in the OFDM Receiver.]
      ]
    ]
  )
]

// ============================================================
// SLIDE 40 — Equalização
// ============================================================
#slide[
  == Equalização OFDM: uma multiplicação por tom

  #set text(size: 16pt)

  Para cada subportadora:

  $ Y[k] = H[k] X[k] + N[k] $

  Se $H[k]$ é conhecido:

  $ hat(X)[k] = Y[k] / H[k] $

  No código:

  - `current_ofdm_symbol`: 64 amostras da janela útil;
  - `current_fft_output`: 64 tons complexos;
  - `equalized_symbol = current_fft_output * equalizer_coefficients`;
  - `DATA_CARRIERS_IDX` extrai os 48 tons de dados.

  #v(0.4em)
  #text(size: 14pt)[Por que funciona: em OFDM com GI suficiente, o canal é quase escalar em cada tom.]
]

// ============================================================
// SLIDE 41 — Pilotos para fase
// ============================================================
#slide[
  == Pilotos: rastrear fase comum

  #set text(size: 15pt)

  // Descrição para acessibilidade: Two side-by-side graphs showing phase offsets across subcarriers. The ideal left graph has phase on the vertical axis from -pi to pi and subcarriers on the horizontal axis; four markers at -21, -7, 7 and 21 lie exactly on the zero phase line. The right graph, phase offset only, has the same four markers shifted upward uniformly by a constant phase, forming a flat horizontal line above zero.
  #align(center)[
    #image("fig/7-49.png", width: 50%)
    #v(-1em)
    #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 7-49: Pilot Tone Phases for Varying Scenarios of Phase Offsets.]
  ]

  Como chega:

  - símbolo equalizado, mas ainda rotacionado por fase residual;
  - pilotos em `[-21, -7, 7, 21]` têm valores conhecidos.

  Transformação:

  - remove a polaridade esperada dos pilotos;
  - calcula uma média complexa ponderada;
  - `theta = angle(averaged_pilot)`;
  - multiplica todos os tons por $e^(-j theta)$.

  Resultado: constelação recentrada angularmente para aquele símbolo OFDM.
]

// ============================================================
// SLIDE 42 — Pilotos para timing
// ============================================================
#slide[
  == Pilotos: rastrear rampa de fase

  #set text(size: 15pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      Um atraso no tempo vira fase linear na frequência:

      $ x(t - t_0) <-> X(f) e^(-j 2 pi f t_0) $

      No código:

      - mede `angle(pilots)`;
      - divide pela posição dos pilotos;
      - combina com pesos `mrc_coef`;
      - suaviza em `average_slope_filter`;
      - corrige cada tom por uma rampa de fase.
    ],
    [
      // Descrição para acessibilidade: Two side-by-side graphs showing phase offsets across subcarriers with timing drift. The left graph, timing offset only, has four markers at -21, -7, 7 and 21 forming a sloped line through the origin: negative subcarriers have negative phase and positive subcarriers have positive phase. The right graph, timing and phase offset, has a tilted line shifted upward so the intercept represents constant phase offset and the slope represents timing offset.
      #align(center)[
        #image("fig/7-50.png", width: 100%)
        #v(-0.6em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 7-50: Pilot Phases for Negative Timing Offset (t_o < 0).]
      ]
      // Descrição para acessibilidade: A system block diagram where x[n] passes a frequency-offset NCO, interpolator, shift register, FFT, equalization, pilot tone processing, final symbols and demapper. Pilot tone processing feeds back error signals to the NCO for phase tracking, to the interpolator for timing tracking and to the equalizer coefficient shift register.
      #align(center)[
        #image("fig/7-51.png", width: 100%)
        #v(-0.6em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 7-51: Pilot Processing Positioning in OFDM Receiver.]
      ]
    ]
  )
]

// ============================================================
// SLIDE 43 — MRC nos pilotos
// ============================================================
#slide[
  == MRC: confiar mais no piloto forte

  #set text(size: 16pt)

  Os quatro pilotos não têm a mesma qualidade quando há fading seletivo.

  - Se $|H[k]|$ é pequeno, aquele piloto tem SNR pior depois da equalização.
  - Média simples dá o mesmo peso para uma medida confiável e uma quase apagada.
  - MRC (_Maximum Ratio Combining_) pondera pela força estimada do canal.

  No código:

  - `pilot_strength = abs(channel_estimate[PILOT_CARRIERS_IDX])`;
  - `mrc_coef = pilot_strength / sum(pilot_strength)`;
  - os mesmos pesos estimam fase comum e inclinação de timing.

  #v(0.4em)
  #text(size: 14pt)[É uma melhoria de implementação: a norma define pilotos, não obriga o algoritmo exato de rastreamento.]
]

// ============================================================
// SLIDE 44 — Loop principal do receptor OFDM
// ============================================================
#slide[
  == Loop principal: um símbolo por vez

  #set text(size: 15.5pt)

  Para cada símbolo OFDM:

  + Calcula `start` e `stop` a partir de `lt_peak_position`, 64 amostras úteis e GI.
  + Extrai 64 amostras da janela FFT.
  + Aplica FFT e equalizador.
  + Usa pilotos para corrigir fase comum.
  + Usa pilotos para corrigir rampa de temporização.
  + Atualiza lentamente coeficientes do equalizador.
  + Guarda só as 48 subportadoras de dados.

  #v(0.4em)
  #text(size: 14pt)[Depois deste ponto, o sinal deixou de ser uma forma de onda: agora é uma sequência de símbolos de constelação.]
]

// ============================================================
// SLIDE 45 — Soft demapper
// ============================================================
#slide[
  == `demapper_ofdm`: símbolo vira confiança de bit

  #set text(size: 13.5pt)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      #align(center)[
        // Descrição para acessibilidade: A processing flowchart mapping bits to analog voltages. Input Bits enter an FEC Encoder, producing Output Bits. These pass into a Bipolar Mapping block with rules 1 maps to +1.0 and 0 maps to -1.0. Noise is added at a summation point. The output passes into a Bit Decision block followed by an FEC Decoder, yielding an estimate of input bits. Below the decision block is a PDF graph with two overlapping bell curves centered at -1.0 and +1.0, illustrating noise spread in softbit values.
        #image("fig/5-68.png", width: 100%)
        #v(-1em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 5-68: Hard or Soft Bits Decisions.]
      ]
    ],
    [
      #align(center)[
        // Descrição para acessibilidade: Two side-by-side PDF graphs over soft bit value from -2 to 2. The low noise plot has two narrow bell curves centered at -1 and +1 with little overlap; a marker at 0.5 is clearly much more likely to be +1. The high noise plot has wider overlapping curves, where a marker at 0.5 has measurable probability under both curves.
        #image("fig/5-69.png", width: 100%)
        #v(-1em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 5-69: Softbits with Varying Noise Powers.]
      ]
    ]
  )

  Hard decision joga fora informação:

  - `+0.05` e `+5.0` virariam o mesmo bit `1`.
  - Viterbi soft precisa saber confiança, não só sinal.

  Na prática:

  - BPSK: LLR aproximado = parte real.
  - QPSK: LLRs aproximados = parte real e parte imaginária intercaladas.
]

// ============================================================
// SLIDE 46 — LLR em BPSK/QPSK
// ============================================================
#slide[
  == LLR simplificado usado na Prática 5

  #set text(size: 16pt)

  Para BPSK/QPSK equalizado e ruído aproximadamente constante:

  - sinal positivo favorece bit `1`;
  - sinal negativo favorece bit `0`;
  - magnitude maior = maior confiança.

  #v(0.3em)
  ```python
  # BPSK
  soft_bits = np.real(symbols_iq)  # aplica a todos os símbolos e devolve um vetor real

  # QPSK
  soft_bits[0::2] = np.real(symbols_iq)  # preenche posições pares: 0, 2, 4, ...
  soft_bits[1::2] = np.imag(symbols_iq)  # preenche posições ímpares: 1, 3, 5, ...
  ```

  #v(0.3em)
  #text(size: 14pt)[Para 16-QAM e 64-QAM, cada bit precisa comparar grupos de níveis possíveis; a aproximação por eixo não basta.]
]

// ============================================================
// SLIDE 47 — BCC + interleaving versus RS
// ============================================================
#slide[
  == Por que código convolucional + interleaving?

  #set text(size: 14pt)

  BCC (_Binary Convolutional Coding_) é um código convolucional binário: cada bit afeta uma sequência curta de bits codificados, que depois é decodificada por Viterbi.

  #v(0.25em)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1.1em,
    [
      *Reed-Solomon no Módulo 4*

      - Código de bloco sobre símbolos, tipicamente bytes.
      - Corrige rajadas curtas naturalmente: vários bits errados podem contar como um símbolo errado.
      - Muito útil quando a camada física entrega decisões mais duras por byte/bloco.
      - Interleaving ainda ajuda se a rajada excede a capacidade de correção do bloco.
    ],
    [
      *802.11a/g OFDM*

      - O demapper gera LLRs por bit.
      - BCC + Viterbi usa essa confiança bit a bit.
      - Fading seletivo cria subportadoras ruins; o interleaver espalha esses erros antes do Viterbi.
      - Baixa latência e hardware previsível para pacotes curtos.
    ],
  )

  #v(0.45em)
  #text(size: 13pt)[A evolução do Wi-Fi também não foi para RS: 802.11n/ac/ax/be adicionam LDPC, que preserva a lógica de usar informação soft e escala melhor para taxas altas.]
]

// ============================================================
// SLIDE 48 — Interleaving
// ============================================================
#slide[
  == `deinterleaving_pattern`: desfazer a permutação

  #set text(size: 16pt)

  Interleaving no transmissor faz duas coisas:

  - evita que bits consecutivos do codificador caiam em subportadoras adjacentes;
  - em QAM alta, espalha bits entre posições de significância diferente.

  No receptor:

  - `soft_bits` chega na ordem em que os símbolos foram demapeados;
  - `deinterleaving_pattern` reordena LLRs para a ordem do codificador;
  - o Viterbi volta a enxergar a treliça na ordem correta.

  #v(0.4em)
  #text(size: 14pt)[Sem deinterleaving, o Viterbi receberia ramos embaralhados: a métrica seria calculada contra o tempo errado.]
]

// ============================================================
// SLIDE 49 — Scrambler
// ============================================================
#slide[
  == `descramble`: desfazer o branqueamento

  #set text(size: 16pt)

  Scrambling não é criptografia.

  - Evita longas sequências de 0 ou 1.
  - Ajuda a manter espectro e estatísticas mais estáveis.
  - Usa LFSR com polinômio $S(x) = x^7 + x^4 + 1$.
  - XOR é sua própria inversa: aplicar a mesma sequência desfaz a operação.

  Em 802.11:

  - `SIGNAL` não passa pelo scrambler -- o scrambler começa a ser sincronizado no `DATA`;
  - os 7 LSBs do campo `SERVICE` (primeiro campo de `DATA`) são zero antes do scrambling;
  - o receptor usa esses bits para estimar o estado inicial;
  - depois desembaralha `SERVICE + PSDU + TAIL + PAD`.
]

// ============================================================
// SLIDE 50 — Código convolucional
// ============================================================
#slide[
  == Código convolucional (BCC) em 802.11

  #set text(size: 16pt)

  #grid(
    columns: (1fr, 1.05fr),
    gutter: 1em,
    [
      BCC (_Binary Convolutional Coding_) é o código convolucional binário usado pelo 802.11a/g clássico. A prática usa:

      - taxa mãe: 1/2;
      - constraint length: $L = 7$;
      - memória: $m = L - 1 = 6$ bits, \ portanto 64 estados;
      - geradores: `133` e `171` em octal;
      - cada bit de entrada produz dois bits codificados.

      #v(0.3em)
      #text(size: 12.5pt)[Taxas 3/4 e 2/3 são obtidas por _puncturing_: alguns bits codificados deixam de ser transmitidos.]
    ],
    [
      #align(center)[
        // Descrição para acessibilidade: The figure displays two schematic block diagrams of tapped delay line shift registers representing convolutional encoders. Both have one input node and three sequential memory registers. Taps connect to modulo-2 adders. In the left rate 1/2 encoder, output 1 taps input, register 2 and register 4, corresponding to g1 = 1101 bin = 15 oct; output 2 taps input and all three registers, corresponding to g2 = 1111 bin = 17 oct. The right rate 1/3 encoder has three modulo-2 outputs with different tap sets.
        #image("fig/5-76.png", width: 100%)
        #v(-1em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 5-76: Rate 1/2 and Rate 1/3 Convolutional Encoders.]
        #v(0.2em)
        #text(size: 10.5pt)[A figura ilustra encoders menores do livro, com $L = 4$; o Wi-Fi usa $L = 7$.]
      ]
    ]
  )
]

// ============================================================
// SLIDE 51 — De onde vêm os geradores BCC
// ============================================================
#slide[
  == Como os geradores BCC são escolhidos?

  #set text(size: 14.5pt)

  Os geradores definem quais taps do registrador entram em cada XOR de saída.
  Para taxa mãe $1\/r$, há $r$ polinômios geradores. Com memória $L-1$, o espaço bruto tem até $(2^L - 1)^r$ combinações; para cada candidata, calcula-se a distância livre $d_"free"$ e o espectro de distâncias, depois valida-se por simulação.

  #grid(
    columns: (1fr, 1fr),
    gutter: 1.2em,
    [
      O que se calcula para cada candidato:

      - evitar códigos catastróficos: uma entrada com quantidade de `1`s tendendo a infinito não pode gerar uma saída com quantidade finita de `1`s;
      - distância livre $d_"free"$: menor distância de Hamming entre dois caminhos codificados distintos;
      - espectro de distâncias: quantos caminhos errados existem perto de $d_"free"$.
    ],
    [
      O que isso garante:

      - maior $d_"free"$ separa melhor o caminho correto dos caminhos errados;
      - melhora a probabilidade de erro do Viterbi, especialmente com métricas soft;
      - não dá uma regra simples "corrige até $t$ erros" como Reed-Solomon;
      - erros próximos, posições e confiabilidade das amostras importam para a decisão.
    ],
  )

  #v(0.25em)
  #text(size: 13pt)[Escolher $L$ é outro compromisso: maior $L$ pode melhorar o código, mas o Viterbi cresce como $2^(L - 1)$ estados.]

  #v(0.15em)
  #text(size: 13pt)[O par `133`/`171` em octal já era um código convolucional clássico de taxa 1/2 e $L = 7$; o IEEE 802.11 adotou essa escolha conhecida.]
]

// ============================================================
// SLIDE 52 — Exemplo de encoder
// ============================================================
#slide[
  == Exemplo trabalhado: encoder pequeno

  #set text(size: 15pt)

  Para entender Viterbi, use um encoder menor: taxa 1/2, $L=3$, geradores `111` e `101`.

  Estado inicial `00`; entrada `1 0 1 1` seguida de cauda `0 0` para terminar em estado conhecido:

  #table(
    columns: (0.45fr, 0.65fr, 1.8fr, 0.65fr),
    inset: 4pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*bit*], [*estado antes*], [*saída*], [*estado depois*]),
    [`1`], [`00`], [`1 ⊕ 0 ⊕ 0 = 1`, $quad$ `1 ⊕ 0 = 1` $quad arrow.r quad$ `11`], [`10`],
    [`0`], [`10`], [`0 ⊕ 1 ⊕ 0 = 1`, $quad$ `0 ⊕ 0 = 0` $quad arrow.r quad$ `10`], [`01`],
    [`1`], [`01`], [`1 ⊕ 0 ⊕ 1 = 0`, $quad$ `1 ⊕ 1 = 0` $quad arrow.r quad$ `00`], [`10`],
    [`1`], [`10`], [`1 ⊕ 1 ⊕ 0 = 0`, $quad$ `1 ⊕ 0 = 1` $quad arrow.r quad$ `01`], [`11`],
    [`0 (tail)`], [`11`], [`0 ⊕ 1 ⊕ 1 = 0`, $quad$ `0 ⊕ 1 = 1` $quad arrow.r quad$ `01`], [`01`],
    [`0 (tail)`], [`01`], [`0 ⊕ 0 ⊕ 1 = 1`, $quad$ `0 ⊕ 1 = 1` $quad arrow.r quad$ `11`], [`00`],
  )

  #v(0.3em)
  Saída codificada: `11 10 00 01 01 11`.

  #text(size: 14pt)[O decoder conhece a máquina de estados. Ele procura qual caminho pela máquina explica melhor a sequência recebida.]
]

// ============================================================
// SLIDE 53 — Treliça
// ============================================================
#slide[
  == Treliça: memória vira grafo no tempo

  #set text(size: 21pt)

  #grid(
    columns: (1fr, 1.6fr),
    gutter: 1em,
    [
      A treliça organiza todas as hipóteses válidas.

      - Cada coluna é um instante de entrada.
      - Cada linha é um estado do registrador.
      - Cada nó tem duas saídas possíveis: bit 0 ou bit 1.
      - O caminho completo codifica a mensagem completa.
    ],
    [
      #align(center)[
        // Descrição para acessibilidade: A trellis graph showing progression of states over discrete time steps. The vertical axis lists eight possible states, 000 through 111. The horizontal axis is discrete time n from 0 to 4. Nodes form a grid at each state and time. Transitions between time steps are solid for input bit 0 and dashed for input bit 1, each labeled with the two-bit encoder output. A bold path starts at state 000, takes input 1 to state 100, input 0 to state 010, input 1 to state 101 and input 1 to state 110, with output labels along the path.
        #image("fig/5-79.png", width: 78%)
        #v(-0.8em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 5-79: Trellis Diagram.]
      ]
    ]
  )
]

// ============================================================
// SLIDE 54 — Viterbi como programação dinâmica
// ============================================================
#slide[
  == Viterbi: métrica, sobrevivente, traceback

  #set text(size: 20pt)

  #grid(
    columns: (1fr, 1.3fr),
    gutter: 1em,
    [
      Algoritmo:

      + Inicialize métricas: estado zero bom, demais ruins.
      + Para cada par de bits recebidos, compute métricas de ramo.
      + Para cada estado destino, compare os dois caminhos que chegam nele.
      + Guarde só o melhor caminho: o sobrevivente.
      + No fim, faça traceback para recuperar os bits.
    ],
    [
      #align(center)[
        // Descrição para acessibilidade: A graphical butterfly diagram for one Viterbi inner-loop step. PreviousLowerState and PreviousUpperState are origin nodes on the left with path metrics. State A and State B are destination nodes on the right. Solid and dashed branches correspond to input bits 0 and 1 and use precomputed encoder outputs for each previous state.
        #image("fig/5-83.png", width: 60%)
        #v(-1em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 5-83: Viterbi Iteration.]
      ]
      #align(center)[
        // Descrição para acessibilidade: An annotated trellis diagram from time n=0 to n=4. The received sequence is [1 1], [1 1], [1 0] and [1 1]. Path metrics PM3 are listed for all eight states at n=3. Between n=3 and n=4, paths entering state 000 are detailed: one from state 000 with output [0 0] has branch metric 2, and one from state 001 with output [1 1] has branch metric 0. The total metrics are compared, the smaller survives, and the survivor is drawn in bold.
        #image("fig/5-82.png", width: 60%)
        #v(-1em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 5-82: Path and Branch Metrics.]
      ]
    ]
  )
]

// ============================================================
// SLIDE 55 — Exemplo Viterbi: passo 1
// ============================================================
#slide[
  // Descrição para acessibilidade: Primeiro quadro do exemplo Viterbi. A treliça do encoder pequeno tem quatro estados, 00, 10, 01 e 11, e colunas n=0 a n=6. No início, só o estado 00 tem métrica zero; os demais estão em infinito. Após o primeiro par recebido RX 11, há duas transições possíveis a partir de 00: entrada 0 produziria 00 e custo 2, entrada 1 produziria 11 e custo 0. O melhor caminho chega ao estado 10 com métrica 0.
  #align(center)[#image("fig/viterbi_trellis_step1.svg", width: 100%)]
]

// ============================================================
// SLIDE 56 — Exemplo Viterbi: passo 2
// ============================================================
#slide[
  // Descrição para acessibilidade: Segundo quadro do exemplo Viterbi. O segundo par recebido é RX 11, marcado em vermelho porque o encoder teria enviado 10 nesse ponto do caminho correto. A transição correta, de estado 10 para estado 01 com entrada 0 e saída esperada 10, recebe custo 1 e fica com métrica acumulada 1. A figura destaca que olhar apenas o par recebido sugeriria outro estado, mas a treliça ainda preserva as hipóteses alcançáveis.
  #align(center)[#image("fig/viterbi_trellis_step2.svg", width: 100%)]
]

// ============================================================
// SLIDE 57 — Exemplo Viterbi: passo 3
// ============================================================
#slide[
  // Descrição para acessibilidade: Terceiro quadro do exemplo Viterbi. A treliça foi expandida até n=3. Pela primeira vez dois caminhos chegam ao mesmo estado; as setas azuis mostram os caminhos sobreviventes de menor métrica, enquanto setas laranja tracejadas mostram caminhos descartados. O erro em n=2 continua marcado em vermelho.
  #align(center)[#image("fig/viterbi_trellis_step3.svg", width: 100%)]
]

// ============================================================
// SLIDE 58 — Exemplo Viterbi: sequência completa
// ============================================================
#slide[
  // Descrição para acessibilidade: Quarto quadro do exemplo Viterbi. A treliça foi expandida até n=6 para os pares recebidos 11, 11, 00, 01, 01 e 11. O erro em n=2 continua marcado em vermelho. As métricas acumuladas aparecem dentro dos nós. Os dois bits finais de cauda 0 0 empurram a decodificação para o estado final conhecido 00.
  #align(center)[#image("fig/viterbi_trellis_step4.svg", width: 100%)]
]

// ============================================================
// SLIDE 59 — Exemplo Viterbi: traceback
// ============================================================
#slide[
  // Descrição para acessibilidade: Quinto quadro do exemplo Viterbi. A treliça completa mostra em verde o caminho sobrevivente escolhido por traceback. A regra é começar pelo estado final de menor métrica acumulada; como há cauda, esse estado de menor custo deve ser 00. O caminho recupera os bits 1, 0, 1, 1, 0 e 0; os dois últimos são cauda e são descartados, restando a mensagem 1, 0, 1, 1.
  #align(center)[#image("fig/viterbi_trellis_step5.svg", width: 100%)]
]

// ============================================================
// SLIDE 60 — Soft Viterbi
// ============================================================
#slide[
  == Viterbi soft-decision

  #set text(size: 16pt)
  Diferença principal:

  - Hard-decision: ramo custa a quantidade de bits diferentes.
  - Soft-decision: ramo pontua correlação entre LLRs recebidos e bits esperados em forma bipolar.

  Para mapeamento 802.11, `0` → -1, `1` → +1:

  $ "BM" = sum_i r_i b_i $

  - `r_i`: LLR ou softbit recebido.
  - `b_i`: saída esperada do encoder em `{-1, +1}`.
  - maximizar $"BM"$ em vez de minimizar custo: maior métrica = melhor compatibilidade.

  #v(0.3em)
  #text(size: 14pt)[Soft-decision costuma dar cerca de 2 dB sobre hard-decision porque preserva confiança.]
]

// ============================================================
// SLIDE 61 — LDPC
// ============================================================
#slide[
  == LDPC: matriz esparsa e grafo de Tanner

  #set text(size: 16pt)

  #align(center)[
    // Descrição para acessibilidade: A Tanner graph corresponding to a parity check matrix H. The top row contains bit nodes labeled b0, b1, b2, p0, p1 and p2. The bottom row contains check nodes C0, C1 and C2. C0 connects to b0, b1, b2 and p0; C1 connects to b0, p0 and p1; C2 connects to b2, p0 and p2. Parity node p0 has multiple connection lines to all three check nodes.
    #image("fig/5-88.png", width: 72%)
    #v(-1em)
    #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 5-88: Parity Check Matrix and Tanner Graph.]
  ]

  LDPC é um código de bloco definido por uma matriz $H$.

  - A palavra-código junta bits de dados e paridade: $x = [b_0 b_1 b_2 p_0 p_1 p_2]$.
  - Palavra válida satisfaz $H x^T = 0$ em GF(2): cada linha de $H$ impõe uma soma XOR que deve dar zero.
  - "Low density" significa poucas conexões por linha/coluna.
  - O grafo de Tanner alterna nós de bit e nós de paridade.
  - Decodificação iterativa troca crenças entre os nós: aqui, "crença" é um LLR sobre um bit.

  #v(0.4em)
  #text(size: 14pt)[802.11n/ac/ax/be usam LDPC como alternativa moderna ao código convolucional binário; 802.11a/g clássico usa BCC com decodificação por Viterbi.]
]

// ============================================================
// SLIDE 62 — LDPC encoder toy
// ============================================================
#slide[
  == Exemplo trabalhado: encoder LDPC pequeno

  #set text(size: 15pt)

  // Descrição para acessibilidade: Exemplo de codificação LDPC pequeno usando a matriz H do slide anterior. A palavra-código x junta três bits de dados e três bits de paridade. Para a mensagem b igual a 1, 0, 1, as três equações de paridade calculam p0 igual a 0, p1 igual a 1 e p2 igual a 1. A palavra final é x igual a 1, 0, 1, 0, 1, 1, e a verificação H vezes x transposto produz zero.
  Usando a matriz do slide anterior, a palavra-código é $x = [b_0 b_1 b_2 p_0 p_1 p_2]$.

  #v(0.2em)
  Cada check impõe uma soma XOR igual a zero:

  #table(
    columns: (0.7fr, 1.25fr, 1.7fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*check*], [*equação*], [*para $b = [1,0,1]$*]),
    [$C_0$], [$b_0 ⊕ b_1 ⊕ b_2 ⊕ p_0 = 0$], [$p_0 = 1 ⊕ 0 ⊕ 1 = 0$],
    [$C_1$], [$b_0 ⊕ p_0 ⊕ p_1 = 0$], [$p_1 = 1 ⊕ 0 = 1$],
    [$C_2$], [$b_2 ⊕ p_0 ⊕ p_2 = 0$], [$p_2 = 1 ⊕ 0 = 1$],
  )

  #v(0.35em)
  Resultado: $x = [1,0,1,0,1,1]$.

  #v(0.2em)
  Verificação: $H x^T = [0,0,0]$, portanto a palavra é válida.

  #v(0.25em)
  #text(size: 13pt)[Este exemplo é didático e pequeno; matrizes LDPC reais de Wi-Fi são muito maiores, mas obedecem à mesma regra $H x^T = 0$.]
]

// ============================================================
// SLIDE 63 — LDPC hard-decision toy
// ============================================================
#slide[
  == Exemplo trabalhado: decodificação por síndrome

  #set text(size: 15pt)

  // Descrição para acessibilidade: Exemplo de decodificação LDPC hard-decision por síndrome. A palavra transmitida x é 1, 0, 1, 0, 1, 1. O canal inverte b2, produzindo y igual a 1, 0, 0, 0, 1, 1. A síndrome H vezes y transposto é 1, 0, 1: os checks C0 e C2 falham. Como a coluna de b2 na matriz H é exatamente 1, 0, 1, o receptor associa essa síndrome ao erro em b2 e recupera x.
  Suponha que o canal inverteu o bit $b_2$:

  $x = [1,0,1,0,1,1] quad arrow.r quad y = [1,0,#text(fill: red)[0],0,1,1]$

  #v(0.2em)
  Calculamos a síndrome $s = H y^T$:

  #table(
    columns: (0.7fr, 1.55fr, 0.75fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*check*], [*soma XOR recebida*], [*síndrome*]),
    [$C_0$], [$1 ⊕ 0 ⊕ 0 ⊕ 0$], [$1$],
    [$C_1$], [$1 ⊕ 0 ⊕ 1$], [$0$],
    [$C_2$], [$0 ⊕ 0 ⊕ 1$], [$1$],
  )

  #v(0.3em)
  Falharam $C_0$ e $C_2$. A coluna de $b_2$ em $H$ é $[1,0,1]^T$, igual à síndrome.

  #v(0.2em)
  Corrigimos $b_2$: $[1,0,0,0,1,1] arrow.r [1,0,1,0,1,1]$.

  #v(0.25em)
  #text(size: 14pt)[Com múltiplos erros, seria preciso buscar quais colunas de $H$, combinadas por XOR, produzem a síndrome; isso não escala. Veremos a seguir o min-sum, que usa os mesmos checks no grafo, mas propaga LLRs.]
]

// ============================================================
// SLIDE 64 — LDPC min-sum
// ============================================================
#slide[
  == Algoritmo min-sum

  #set text(size: 12.2pt)

  Uma iteração LDPC min-sum:

  1. Bits enviam crenças atuais para checks conectados.
  2. Cada check é uma linha de $H$ e calcula mensagens usando os outros bits daquela linha.
  3. Com `0 -> -1` e `1 -> +1`, um check de grau $d$ exige produto de sinais $(-1)^d$.
  4. Sinal da mensagem: produto exigido pela paridade vezes os sinais dos outros bits.
  5. Magnitude da mensagem: menor magnitude entre os outros bits.
  6. Cada bit soma crença original + mensagens dos checks; repete até $H x^T = 0$ ou limite de iterações.

  #v(0.25em)
  Exemplo da figura da esquerda: ao calcular a mensagem para $r[0]$, considere apenas $r[1..3]$. \
  Sinal: $(-) dot (-) dot (+) = +$. Magnitude: $min(1.0, 0.9, 1.2) = 0.9$. Logo $l[0] = +0.9$.

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      #align(center)[
        // Descrição para acessibilidade: A diagram showing a single check node C connected to four received belief nodes r[0] through r[3]. The check receives beliefs and returns extrinsic messages l[0] through l[3].
        #image("fig/5-90.png", height: 1.55in)
        #v(-0.8em)
        #text(size: 7pt)[Schwarzinger, Figure 5-90: Single Parity Check Node.]
      ]
    ],
    [
      #align(center)[
        // Descrição para acessibilidade: A node-connection diagram centered on a bit node r[x]. Several check nodes send extrinsic messages l0[x], l1[x], l2[x] and so on to the bit node, whose updated belief is the original belief plus the sum of incoming messages.
        #image("fig/5-91.png", height: 1.55in)
        #v(-0.8em)
        #text(size: 7pt)[Schwarzinger, Figure 5-91: Updating Intrinsic Belief.]
      ]
    ],
  )
]

// ============================================================
// SLIDE 65 — LDPC min-sum step 1
// ============================================================
#slide[
  // Descrição para acessibilidade: Primeiro quadro da animação min-sum. O grafo LDPC tem nós de bit b0, b1, b2, p0, p1 e p2 e checks C0, C1 e C2. Cada bit mostra um LLR recebido e sua decisão hard inicial pela regra sinal positivo vira bit 1 e sinal negativo vira bit 0. Todos os nós aparecem com estilo neutro; o quadro não identifica previamente qual bit está errado.
  #align(center)[#image("fig/ldpc_minsum_step1.svg", width: 100%)]
]

// ============================================================
// SLIDE 66 — LDPC min-sum step 2
// ============================================================
#slide[
  // Descrição para acessibilidade: Segundo quadro da animação min-sum. Todos os check nodes enviam mensagens extrínsecas para todos os bits vizinhos. As setas check para bit aparecem em todas as arestas do grafo, com rótulos numéricos positivos em azul e negativos em marrom. O quadro enfatiza que nenhum bit foi escolhido previamente como erro; todas as mensagens são calculadas em paralelo a partir das conexões de H.
  #align(center)[#image("fig/ldpc_minsum_step2.svg", width: 100%)]
]

// ============================================================
// SLIDE 67 — LDPC min-sum step 3
// ============================================================
#slide[
  // Descrição para acessibilidade: Terceiro quadro da animação min-sum. Cada bit soma seu LLR original com todas as mensagens recebidas. Um único nó muda de sinal e de decisão hard, aparecendo em verde. O texto explica que depois dessa atualização todos os checks ficam consistentes e que esse nó era o bit invertido pelo canal.
  #align(center)[#image("fig/ldpc_minsum_step3.svg", width: 100%)]
]

// ============================================================
// SLIDE 68 — Projeto e validação de LDPC
// ============================================================
#slide[
  == Como a matriz $H$ é escolhida?

  #set text(size: 13.2pt)

  $H$ é uma escolha de projeto do código, não uma matriz gerada a partir da mensagem.

  - Escolhe-se comprimento da palavra-código $n$, bits úteis $k$ e taxa $R = k\/n$.
  - Graus dos nós e estrutura do grafo buscam convergência iterativa e poucos ciclos curtos.
  - Uma construção estruturada transforma a ideia em matriz implementável; o próximo slide mostra essa estrutura.

  #grid(
    columns: (1fr, 1fr),
    gutter: 1.1em,
    [
      No TGn/802.11, as propostas convergiram para códigos estruturados:

      - matrizes-semente pequenas $H_b$;
      - expansão por matrizes de permutação cíclicas;
      - várias taxas, comprimentos $n$ e fatores de expansão $Z$ com baixa memória de descrição;
      - encoding quase linear;
      - a matriz também é escolhida pensando no decoder:
        LDPC usa passagem iterativa de LLRs no grafo de Tanner; nos documentos isso aparece como BP (_belief propagation_), SPA (_sum-product_) e _layered BP_.
    ],
    [
      A seleção é validada por simulação, não por uma garantia simples de "corrige até $t$ erros":

      - BER (probabilidade de erro por bit), BLER (por bloco LDPC) e PER (por pacote/quadro) versus SNR em AWGN e canais relevantes;
      - tamanhos de pacote, taxas e número de iterações;
      - _error floor_, throughput, área, memória e consumo.
    ],
  )

  #v(0.1em)
  #text(size: 10.5pt)[Fonte: #link("https://mentor.ieee.org/802.11/dcn/04/11-04-1362-00-000n-structured-ldpc-code-design.doc")[IEEE 802.11-04/1362r0, "Structured LDPC code design"].]
]

// ============================================================
// SLIDE 69 — De onde vem H
// ============================================================
#slide[
  == LDPC estruturado: de $H_b$ para $H$

  #set text(size: 13.4pt)

  #let blk(body, fill: rgb("#eef3ff")) = table.cell(fill: fill, inset: 5pt)[#align(center)[#body]]
  #let zblk(body, fill: rgb("#eef8ef")) = table.cell(fill: fill, inset: 5pt)[#align(center)[#body]]
  #let bit(body, fill: white) = table.cell(fill: fill, inset: 2.5pt)[#align(center)[#body]]

  $H_b$ é uma matriz-base pequena. Cada entrada vira um bloco $Z times Z$ na matriz real $H$:

  #v(1em)
  #grid(
    columns: (1.25fr, 0.18fr, 1.25fr),
    gutter: 0.7em,
    [
      #align(center)[
        #table(
          columns: 4,
          stroke: 0.8pt,
          align: horizon,
          blk[$-$], blk[$0$], blk[$2$], blk[$-$],
          blk[$1$], blk[$-$], blk[$0$], blk[$3$],
          blk[$-$], blk[$2$], blk[$-$], blk[$0$],
        )
        #v(0.25em)
        $H_b$: $m_b = 3$ linhas, $n_b = 4$ colunas
      ]
    ],
    [
      #v(1.5em)
      #text(size: 22pt)[$arrow.r$]
    ],
    [
      #align(center)[
        #table(
          columns: 4,
          stroke: 0.8pt,
          align: horizon,
          zblk[$0$], zblk[$I$], zblk[$P^2$], zblk[$0$],
          zblk[$P^1$], zblk[$0$], zblk[$I$], zblk[$P^3$],
          zblk[$0$], zblk[$P^2$], zblk[$0$], zblk[$I$],
        )
        #v(0.25em)
        $H$: $m_b Z$ checks por $n_b Z$ bits
      ]
    ],
  )

  #v(2em)
  #grid(
    columns: (1fr, 0.4fr),
    gutter: 1.2em,
    [
      - Entrada “--” em $H_b$: bloco zero, sem conexões no grafo.
      - Entrada $p >= 0$: identidade cíclica $P^p$ (vide exemplo ao lado); desloca conexões dentro do bloco.
      - O tamanho do código aparece nas dimensões: $n = n_b Z$ é o comprimento; se todos os checks são independentes, $k = n - m_b Z$ bits úteis.
      - A norma escolhe diferentes matrizes-base, fatores $Z$ e taxas para obter códigos implementáveis em hardware.
    ],
    [
      #align(center)[
        #text(size: 11pt)[Exemplo de bloco, $Z = 4$:]
        #v(0.15em)
        #table(
          columns: 4,
          stroke: 0.65pt,
          align: horizon,
          bit[$0$], bit[$1$], bit[$0$], bit[$0$],
          bit[$0$], bit[$0$], bit[$1$], bit[$0$],
          bit[$0$], bit[$0$], bit[$0$], bit[$1$],
          bit[$1$], bit[$0$], bit[$0$], bit[$0$],
        )
        #v(0.1em)
        #text(size: 11pt)[$P^1$: identidade deslocada]
      ]
    ],
  )
]

// ============================================================
// SLIDE 70 — BCC versus LDPC
// ============================================================
#slide[
  == BCC versus LDPC

  #set text(size: 15pt)

  #align(center)[
    // Descrição para acessibilidade: A BER plot on a logarithmic vertical axis from 1e-6 to 1 and SNR dB on the horizontal axis from -0.5 to 4. Four curves are shown: Polar, LDPC, Turbo and BCC. The BCC curve decreases slowly and steadily as SNR grows. Polar, LDPC and Turbo show waterfall behavior, dropping sharply over a narrow SNR range and reaching below 1e-6 near 2 dB.
    #image("fig/5-92.png", width: 48%)
    #v(-0.8em)
    #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 5-92: Rate 1/2 FEC Performance Comparison.]
  ]

  - BCC + Viterbi: bom para mensagens curtas, baixa latência e hardware previsível.
  - LDPC: melhor para blocos longos e opera mais perto do limite de Shannon.
  #v(0.3em)
  - BCC melhora gradualmente com SNR.
  - LDPC tem comportamento de "waterfall": pouco ganho abaixo de certo SNR, queda abrupta de BER acima dele.
  #v(0.3em)
  - Wi-Fi evoluiu de BCC obrigatório em 802.11a/g para LDPC opcional em gerações posteriores, com uso cada vez mais relevante em taxas altas.
]

// ============================================================
// SLIDE 71 — Por que LDPC, não Turbo?
// ============================================================
#slide[
  == Por que Wi-Fi ficou com LDPC?

  #set text(size: 13.2pt)

  // Descrição para acessibilidade: slide em duas colunas. A coluna esquerda resume a linha do tempo: LDPC aparece na tese de Gallager em 1960, Turbo codes são publicados em 1993, LDPC é redescoberto por MacKay e Neal em 1995 e 1996, e Polar codes aparecem depois do processo do 802.11n. A coluna direita explica que a escolha do Wi-Fi não depende apenas da curva de BER: Turbo foi proposto ao TGn, mas tinha patente fundamental ativa e decodificador iterativo mais complexo; LDPC estruturado foi defendido por matrizes pequenas expandidas ciclicamente, baixo armazenamento, bom BLER em pacotes, codificação quase linear e decodificação layered BP.
  #grid(
    columns: (0.95fr, 1.05fr),
    gutter: 1.2em,
    [
      #text(weight: "bold")[Linha do tempo]

      - 1960/1962/1963: Gallager propõe LDPC; a ideia era boa, mas cara demais para o hardware da época.
      - 1993: Turbo codes mostram desempenho muito perto do limite de Shannon e mudam a área.
      - 1995/1996: MacKay e Neal mostram LDPC esparso com desempenho também próximo ao limite.
      - 2009: Polar codes aparecem depois das escolhas técnicas do 802.11n.
    ],
    [
      #text(weight: "bold")[Decisão prática no TGn]

      - As atas do TGn tratavam Turbo e LDPC como alternativas de desempenho parecido em primeira ordem; a curva anterior não decidia o padrão sozinha.
      - A latência era concreta: 1600 bits a 240 Mb/s já levam 6,6 µs só para chegar ao receptor; sobrava um orçamento pequeno, da ordem de 1 µs, para o FEC.
      - Turbo foi proposto, mas trazia patente fundamental ativa, interleaver e troca iterativa de informação extrínseca; o LDPC estruturado favorecia pacotes e hardware: matriz-semente pequena, expansão cíclica, baixo armazenamento, encoding quase linear e _layered BP_.
      - Resultado: 802.11n adotou LDPC como opção; Turbo não entrou no Wi-Fi.
    ],
  )

  #v(0.2em)
  #text(size: 9.2pt)[Fontes: #link("https://mitpress.mit.edu/9780262070072/low-density-parity-check-codes/")[Gallager, _Low-Density Parity-Check Codes_]; #link("https://doi.org/10.1109/ICC.1993.397441")[Berrou et al., ICC 1993]; #link("https://doi.org/10.1049/el:19961141")[MacKay e Neal, 1996]; #link("https://patents.google.com/patent/US5446747A/en")[US 5,446,747]; #link("https://mentor.ieee.org/802.11/dcn/04/11-04-0902-00-000n-turbo-codes-partial-proposal-disclosure.doc")[IEEE 802.11-04/0902r0]; #link("https://mentor.ieee.org/802.11/dcn/04/11-04-1362-00-000n-structured-ldpc-code-design.doc")[IEEE 802.11-04/1362r0]; #link("https://doi.org/10.1109/TIT.2009.2021379")[Arikan, 2009].]
]

// ============================================================
// SLIDE 72 — Decodificação final
// ============================================================
#slide[
  == Dos símbolos aos bytes

  #set text(size: 14.2pt)

  // Descrição para acessibilidade: diagrama com dois trilhos paralelos. No trilho superior, o campo SIGNAL começa em "48 símbolos SIGNAL" e passa por demapper BPSK, deinterleaver, Viterbi e parser de RATE, LENGTH, PARITY e TAIL. O parser produz os indicadores `parity_ok` e `tail_ok` e também fornece MCS e LENGTH para parametrizar o trilho DATA. No trilho inferior, "símbolos DATA" passa por demapper conforme a taxa escolhida pelo SIGNAL, deinterleaver por símbolo, Viterbi, descrambler, separação SERVICE/PSDU/TAIL, packbits e CRC32. O CRC32 produz `crc_ok` e os bytes PSDU. Setas vermelhas indicam que falhas em paridade, tail ou CRC descartam ou marcam o quadro como inválido.
  #align(center)[#image("fig/final_bit_decode.svg", width: 98%)]
  #v(-0.25em)

  - `decode_signal_field()`: sempre BPSK 1/2; descobre taxa e comprimento.
  - `decode_data_symbols()`: usa parâmetros do `SIGNAL`; recupera PSDU.
  - O CRC não corrige; ele confirma se a sequência corrigida pela FEC é plausível.
]

// ============================================================
// SLIDE 73 — Depuração com EVM
// ============================================================
#slide[
  == Depuração: EVM no tempo e na frequência

  #set text(size: 15.5pt)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      #align(center)[
        // Descrição para acessibilidade: A top-level block diagram of the software simulation. The OFDM Transmitter takes number of OFDM symbols, bits per constellation position and transmitter IFFT64 or 128, and outputs a sample stream plus an ideal TX symbol stream. A Channel Defect Model takes the sample stream and mode/settings flags for defects and outputs a corrupted sample stream. The OFDM Receiver operates at 20MHz with sample advance, number of symbols, max ratio combining and frequency correction flags, outputting the processed RX symbol stream. An EVM and Performance Metric Calculator compares RX symbols to ideal TX symbols.
        #image("fig/7-62.png", width: 88%)
        #v(-1em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 7-62: Code Flow of OFDM Transceiver.]
      ]
    ],
    [
      #align(center)[
        // Descrição para acessibilidade: Two performance plots. EVM versus frequency shows points tightly around a flat horizontal line near -26 dB across tones. EVM versus time shows a continuous line fluctuating tightly around -26 dB over all OFDM symbols.
        #image("fig/7-52.png", width: 88%)
        #v(-1em)
        #text(size: 8pt)[Schwarzinger, Digital Signal Processing in Modern Communication Systems, Figure 7-52: EVM Performance at 25 dB SNR.]
      ]
    ]
  )

  Use os gráficos como diagnóstico:

  - Ruído branco: EVM quase plano em frequência e tempo.
  - Multi-caminho: EVM varia com a subportadora.
  - Fase residual: EVM piora com o tempo ou constelação gira.
  - Timing jitter: tons externos sofrem mais.
  - Erro de deinterleaver/Viterbi: constelação pode parecer boa, mas bits falham.
]

// ============================================================
// SLIDE 74 — Fechamento
// ============================================================
#slide[
  == Checklist mental do receptor 802.11

  #set text(size: 17pt)

  Para cada quadro recebido, pergunte:

  + O pacote foi detectado pela periodicidade da STS?
  + A frequência foi corrigida antes da FFT?
  + A janela FFT está dentro da região segura do GI?
  + O canal estimado pela LTS faz sentido em magnitude e fase?
  + Os pilotos estão corrigindo fase comum e rampa de timing?
  + Os LLRs preservam confiança para o Viterbi?
  + Deinterleaver, descrambler, cauda e CRC concordam?

  #v(0.5em)
  #text(size: 14pt)[Esse é o caminho completo do Wi-Fi baseado em SDR: RF vira amostras, amostras viram tons, tons viram símbolos, símbolos viram LLRs/crenças, crenças viram bits, bits viram quadro.]
]
