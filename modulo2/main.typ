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

    Módulo 2 -- E1, códigos de linha, sincronização, \
    enquadramento e sinalização

    #text(size: 18pt)[Base teórica para a Prática 2]

    Prof. Paulo Matias
  ]
]

// ============================================================
// SLIDE 2 — Objetivos
// ============================================================
#slide[
  == Objetivos deste módulo

  Ao fim desta aula, o aluno deve saber responder:

  - Por que o E1 usa HDB3 e não NRZ, AMI puro ou Manchester?
  - Como o receptor recupera o clock e por que a DPLL converge?
  - Como um fluxo serial vira timeslots E1 e depois quadros HDLC?
  - Como o CRC detecta erros e por que ele cabe tão bem em hardware?
  - Onde ficam voz, sinalização e dados dentro do quadro E1?

  #v(0.5em)
  #text(size: 20pt)[_A prática não é uma coleção de blocos arbitrários --- cada bloco resolve um problema físico concreto do enlace._]
]

// ============================================================
// SLIDE 3 — Pipeline da Prática 2
// ============================================================
#slide[
  == Pipeline da Prática 2: visão de sistema

  #v(0.5em)
  #align(center)[
    #set text(size: 14pt)
    #fletcher.diagram(
      spacing: (0.6em, 1.8em),
      node-stroke: 0.8pt,
      edge-stroke: 0.8pt,
      node((0,0), [Cabo E1]),
      edge("-|>"),
      node((1,0), [ThreeLevelIO\ + DPLL], shape: fletcher.shapes.pill),
      edge("-|>"),
      node((2,0), [HDB3\ Decoder], shape: fletcher.shapes.pill),
      edge("-|>"),
      node((3,0), [E1\ Unframer], shape: fletcher.shapes.pill),
      edge("-|>"),
      node((4,0), [HDLC\ Unframer], shape: fletcher.shapes.pill),
      edge("-|>"),
      node((5,0), [ICMP\ Replier], shape: fletcher.shapes.pill),
      edge((5,0), (5,1), "-|>"),
      node((5,1), [HDLC\ Framer], shape: fletcher.shapes.pill),
      edge("-|>"),
      node((4,1), [HDB3\ Encoder], shape: fletcher.shapes.pill),
      edge("-|>"),
      node((3,1), [Cabo E1]),
    )
  ]
  #v(0.3em)
  #set text(size: 17pt)
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0.6em,
    [*DPLL:* quando amostrar?],
    [*HDB3Dec:* que bits?],
    [*E1Unframer:* qual timeslot?],
    [*HDLCUnframer:* onde começa/termina o pacote?],
    [*ICMPReplier:* como gerar a resposta?],
    [],
  )
]

// ============================================================
// SLIDE 4 — Voz, sinalização e dados no mesmo E1
// ============================================================
#slide[
  == Voz, sinalização e dados: tudo no mesmo E1

  - Historicamente, o E1 nasceu para voz PCM.
  - Na Prática 2, nós o usamos para dados sobre HDLC.
  - De modo geral, o mesmo E1 pode carregar:
    - voz codificada em PCM
    - sinalização CAS em TS16
    - dados síncronos em canais fracionados
  
  #v(1em)
  _Isso faz do E1 um excelente exemplo de integração entre teoria de telecomunicações e arquitetura de redes._
]

// ============================================================
// SLIDE 5 — Recapitulação do módulo 1
// ============================================================
#slide[
  == Notação do módulo 1 (recapitulação rápida)

  #set text(size: 23pt)

  No módulo 1, modelamos transmissão em banda base como:

  $ x(t) = sum_n a[n] thin p(t-n T) $

  A mesma ideia continua valendo, mas agora o foco passa a ser:
  - Quais formas de onda escolhemos para o meio físico
  - Como detectar símbolos na presença de ruído, distorção e erro de temporização
  - Como transformar a sequência de símbolos em estrutura de enlace
]

// ============================================================
// SLIDE 6 — De voz analógica a 64 kbit/s
// ============================================================
#slide[
  == De voz analógica a 64 kbit/s

  #grid(
    columns: (1.3fr, 1fr),
    gutter: 1em,
    [
      - Banda de voz telefônica: \ ~300 Hz a 3400 Hz
      - Amostragem a 8 kHz $arrow.r$ \ 1 amostra a cada 125 µs
      - Quantização em 8 bits $arrow.r$ \ $8000 times 8 = 64$ kbit/s por canal
      - Esse canal de 64 kbit/s é o \ "átomo" do E1
    ],
    [
      #image("E1_acterna_figure1.svg", width: 100%)
      #v(-0.8em)
      #text(size: 10pt)[Tibbs, _Pocket Guide to The world of E1_, 2002, obtido de #link("https://web.archive.org/web/20240429125245/https://web.fe.up.pt/~mleitao/STEL/Tecnico/E1_ACTERNA.pdf")[web.fe.up.pt].]
    ]
  )
]

// ============================================================
// SLIDE 7 — Lei A: por que companding?
// ============================================================
#slide[
  == Lei A e lei µ: por que companding?

  #grid(
    columns: (1.3fr, 1fr),
    gutter: 1em,
    [
      - Quantização linear com poucos bits: sinais fracos sofrem muito mais ruído relativo.
      - _Companding_ redistribui os níveis de quantização.
      - E1 / Europa / Brasil: *lei A*.
      - T1 / EUA / Japão: *lei µ*.
      - Intuição: mais resolução perto de zero, menos para amplitudes grandes.
    ],
    [
      #image("E1_acterna_figure2.svg", width: 100%)
      #v(-0.8em)
      #text(size: 10pt)[Tibbs, _Pocket Guide to The world of E1_, 2002, obtido de #link("https://web.archive.org/web/20240429125245/https://web.fe.up.pt/~mleitao/STEL/Tecnico/E1_ACTERNA.pdf")[web.fe.up.pt].]
    ]
  )
]

// ============================================================
// SLIDE 8 — Cálculo do E1: por que 2,048 Mbit/s
// ============================================================
#slide[
  == Por que 2,048 Mbit/s?

  #set text(size: 23pt)

  - 1 quadro PCM dura *125 µs*.
  - Cada quadro tem *32 timeslots*.
  - Cada timeslot tem *8 bits*.

  $ 32 times 8 = 256 "bits/quadro" $
  $ 256 "bits" / 125 mu s = 2.048.000 "bit/s" $

  - No PCM30: 30 canais de tráfego + TS0 (sincronismo) + TS16 (sinalização)
  
  #text(size: 14pt)[_Esses sistemas nasceram antes dos microprocessadores modernos: os primeiros bancos PCM já faziam TDM e regeneração com eletrônica discreta._]
]

// ============================================================
// SLIDE 9 — Estrutura do quadro E1
// ============================================================
#slide[
  == Estrutura do quadro E1

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      #align(center)[
        *PCM31*
        #image("E1_acterna_PCM31.svg", width: 95%)
      ]
    ],
    [
      #align(center)[
        *PCM30*
        #image("E1_acterna_PCM30.svg", width: 95%)
      ]
    ],
  )

  #v(0.5em)
  #text(size: 20pt)[
    - PCM31: TS0 para sincronismo, TS1--31 para tráfego.
    - PCM30: TS0 para sincronismo, TS16 para sinalização, demais para tráfego.
    - Na prática brasileira, o formato principal é o *PCM30*.
  ]
]

// ============================================================
// SLIDE 10 — TS0: FAS / NFAS
// ============================================================
#slide[
  == TS0: alternância FAS / NFAS

  #align(center)[
    #image("E1_acterna_figure5.svg", width: 52%)
    #v(-0.5em)
    #text(size: 9pt)[Tibbs, _Pocket Guide to The world of E1_, 2002, obtido de #link("https://web.archive.org/web/20240429125245/https://web.fe.up.pt/~mleitao/STEL/Tecnico/E1_ACTERNA.pdf")[web.fe.up.pt].]
  ]

  #set text(size: 20pt)
  - Quadros pares: TS0 carrega o *FAS* (padrão `0011011` nos bits 2--8).
  - Quadros ímpares: TS0 carrega o *NFAS*.
  - Essa alternância permite ao receptor encontrar a fronteira de quadro.
  - O bit 1 do TS0 não faz parte do padrão e pode ser reaproveitado para CRC-4.
]

// ============================================================
// SLIDE 11 — Máquina de estados do E1Unframer
// ============================================================
#slide[
  == Máquina de estados do `E1Unframer`

  #v(0.5em)
  #fletcher.diagram(
    spacing: 2.5em,
    node-stroke: 1pt,
    edge-stroke: 1pt,
    node((0,0), [`UNSYNCED`]),
    edge((0,0), (1,0), "->", [candidato FAS], label-side: right, label-sep: 16pt),
    node((1,0), [`FIRST_FAS`]),
    edge((1,0), (2,0), "->", [NFAS OK], label-side: right, label-sep: 16pt),
    node((2,0), [`FIRST_NFAS`]),
    edge((2,0), (3,0), "->", [FAS OK], label-side: right, label-sep: 16pt),
    node((3,0), [`SYNCED`]),
    edge((3,0), (0,0), "->", bend: -40deg, [falha], label-side: right, label-sep: 8pt),
  )

  #v(1em)
  #text(size: 20pt)[
    Não basta encontrar "`0011011`" uma vez --- é preciso provar que aquilo realmente é TS0 e não coincidência nos dados.
  ]
]

// ============================================================
// SLIDE 12 — TS16 e a multitrama de sinalização
// ============================================================
#slide[
  == TS16 e a multitrama de sinalização

  #set text(size: 22pt)

  #grid(
    columns: (1.2fr, 1fr),
    gutter: 1em,
    [
      - TS16 carrega sinalização CAS, não áudio.
      - Uma multitrama = *16 quadros = 2 ms*.
      - Em cada TS16 cabem dois canais de sinalização ABCD.
      - Taxa suficiente para representar sinais lentos como pulso decádico (~dezenas de ms por pulso).
    ],
    [
      #image("E1_acterna_figure9.svg", width: 94%)
      #v(-0.8em)
      #text(size: 9pt)[Tibbs, _Pocket Guide to The world of E1_, 2002, obtido de #link("https://web.archive.org/web/20240429125245/https://web.fe.up.pt/~mleitao/STEL/Tecnico/E1_ACTERNA.pdf")[web.fe.up.pt].]
    ],
  )

  #text(size: 14pt)[_Sinalização é lenta; voz e dados são rápidos. Por isso faz sentido tirar a sinalização do canal de voz e colocá-la em TS16._]
]

// ============================================================
// SLIDE 13 — CRC-4 no E1
// ============================================================
#slide[
  == CRC-4 no E1

  #grid(
    columns: (1.2fr, 1fr),
    gutter: 1em,
    [
      - Sem CRC-4: receptor monitora apenas FAS/NFAS.
      - Com CRC-4: verifica blocos de *8 quadros inteiros*.
      - Bloco CRC: $8 times 256 = 2048$ bits.
      - Polinômio gerador: $x^4 + x + 1$.
      - Os 4 bits de resto vão no bit 1 dos TS0 dos quadros FAS seguintes.
    ],
    [
      #image("E1_acterna_figure12.svg", width: 100%)
      #v(-0.8em)
      #text(size: 10pt)[Tibbs, _Pocket Guide to The world of E1_, 2002, obtido de #link("https://web.archive.org/web/20240429125245/https://web.fe.up.pt/~mleitao/STEL/Tecnico/E1_ACTERNA.pdf")[web.fe.up.pt].]
    ],
  )

  #v(0.2em)
  #text(size: 18pt)[_No teste de bancada, o Cisco está configurado com `NO-CRC4`, mas o conceito é central na tecnologia E1 real._]
]

// ============================================================
// SLIDE 14 — Alarmes em E1
// ============================================================
#slide[
  == Alarmes em E1

  #set text(size: 22pt)
  - *RAI* (Remote Alarm Indication): bit A do NFAS avisa a ponta remota que algo está errado.
  - *AIS* (Alarm Indication Signal): sequência quase toda em 1, para manter clock nos regeneradores.
  - *Perda de frame sync:* três FAS incorretos consecutivos.
  - *Perda de multiframe sync:* problema na estrutura de TS16.

  #v(1em)
  #text(size: 18pt)[_A Prática 2 trata apenas o sincronismo por FAS/NFAS; os demais alarmes aparecem aqui como parte da tecnologia E1 real._]
]

// ============================================================
// SLIDE 15 — Interface física E1
// ============================================================
#slide[
  == Interface física E1 segundo G.703

  #grid(
    columns: (1.3fr, 1fr),
    gutter: 1em,
    [
      - Par simétrico de 120 Ω ou \ coaxial de 75 Ω
      - Pulso nominal ~retangular, \ largura ~244 ns
      - Máscara de pulso e jitter máximo padronizados
      - _O padrão não define só os bits; define a forma de onda no conector._
    ],
    [
      #image("E1_acterna_figure19.svg", width: 100%)
      #v(-0.8em)
      #text(size: 10pt)[Tibbs, _Pocket Guide to The world of E1_, 2002, obtido de #link("https://web.archive.org/web/20240429125245/https://web.fe.up.pt/~mleitao/STEL/Tecnico/E1_ACTERNA.pdf")[web.fe.up.pt].]
    ],
  )
]

// ============================================================
// SLIDE 16 — Requisitos de um bom código de linha
// ============================================================
#slide[
  == Requisitos de um bom código de linha

  #set text(size: 22pt)
  Código de linha = regra que transforma bits em forma de onda elétrica no cabo.

  + Garantir transições suficientes para recuperação de clock
  + Evitar componente DC e _baseline wander_
  + Usar banda de forma eficiente
  + Ter complexidade aceitável
  + Se possível, permitir detecção de certas falhas

  #v(0.5em)
  #text(size: 22pt)[_Qual combinação desses objetivos levou a indústria do E1 ao HDB3?_]
]

// ============================================================
// SLIDE 17 — Panorama visual dos códigos de linha
// ============================================================
#slide[
  == Panorama visual dos códigos de linha

  #align(center)[
    #image("dayan_figure4_1.jpg", width: 56%)
    #v(-0.8em)
    #text(size: 9pt)[Guimarães, _Digital Transmission_, 2009, obtido de #link("https://doi.org/10.1007/978-3-642-01359-1")[doi.org].]
  ]

  #text(size: 14pt)[_Mesma sequência binária, formas de onda diferentes, compromissos diferentes._]
]

// ============================================================
// SLIDE 18 — NRZ e RZ
// ============================================================
#slide[
  == NRZ e RZ: os pontos de partida

  #set text(size: 22pt)
  - *NRZ unipolar:* simples, mas tem DC e pode ficar "parado" por muito tempo.
  - *NRZ bipolar (antipodal):* sem DC para bits equiprováveis, mas pode ter poucas transições.
  - *RZ:* volta a zero dentro do intervalo de bit.
    - Vantagem: mais transições.
    - Desvantagem: ocupa mais largura de banda.

  #v(0.5em)
  _Bons códigos didáticos, mas não resolvem bem o problema prático do E1._
]

// ============================================================
// SLIDE 19 — AMI
// ============================================================
#slide[
  == AMI: o ancestral direto do HDB3

  #grid(
    columns: (1.3fr, 1fr),
    gutter: 1em,
    [
      - Bit 1 → pulso alternando polaridade
      - Bit 0 → ausência de pulso
      - Vantagens: sem DC, capacidade de detectar violação.
      - *Problema fatal para E1:* longas sequências de 0 não carregam relógio.
    ],
    [
      #image("E1_acterna_figure16.svg", width: 100%)
      #v(-0.8em)
      #text(size: 10pt)[Tibbs, _Pocket Guide to The world of E1_, 2002, obtido de #link("https://web.archive.org/web/20240429125245/https://web.fe.up.pt/~mleitao/STEL/Tecnico/E1_ACTERNA.pdf")[web.fe.up.pt].]
    ],
  )
  #v(0.5em)
  _HDB3 = "AMI + remédio para sequências longas de zero"._
]

// ============================================================
// SLIDE 20 — Manchester, Miller e CMI
// ============================================================
#slide[
  == Manchester, Miller e CMI: comparação breve

  #set text(size: 18pt)
  #table(
    columns: (1fr, 2fr, 2fr),
    inset: 7pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Código*], [*Características*], [*Uso típico*]),
    [Manchester], [Sempre há transição no meio do bit; robusto para clock recovery; ocupa mais banda], [Ethernet 10 Mbps (voltará no módulo 3)],
    [Miller], [Codificação por transições; Modified Miller usado em RFID (ISO/IEC 14443 Type A)], [Cartões sem contato],
    [CMI], [Sem DC; boa atividade de transições; padronizado na G.703 para taxas mais altas do PDH], [Interfaces PDH de taxa mais alta],
  )
]

// ============================================================
// SLIDE 21 — HDB3: a ideia
// ============================================================
#slide[
  == HDB3: a ideia em uma frase

  #v(0.6em)
  #align(center)[
    #text(size: 27pt, weight: "bold")[AMI com substituição controlada \ de 4 zeros consecutivos]
  ]
  
  #v(0.5em)
  - Quando o fluxo ficaria sem transições por tempo demais, o codificador injeta pulsos especiais.
  - Esses pulsos preservam a média DC próxima de zero e criam um padrão detectável no receptor.

  #text(size: 18pt)[_Esse é o compromisso exato de que o E1 precisava._]
]

// ============================================================
// SLIDE 22 — HDB3: regras 000V e B00V
// ============================================================
#slide[
  == HDB3: regras `000V` e `B00V`

  #set text(size: 22pt)
  - *Regra 1:* `0000` → `000V`
  - *Regra 2:* se o número de pulsos desde a última violação for par, usar `B00V`

  #v(0.5em)
  - *B* = pulso bipolar "normal" (obedece à alternância AMI)
  - *V* = pulso de *violação* (mesma polaridade do pulso anterior, quebrando a alternância)

  #v(0.5em)
  _B corrige a paridade; V cria a assinatura detectável da substituição._
]

// ============================================================
// SLIDE 23 — HDB3 em exemplos concretos
// ============================================================
#slide[
  == HDB3 em exemplos concretos

  #align(center)[
    #image("E1_acterna_figure17.svg", width: 50%)
    #v(-0.5em)
    #text(size: 9pt)[Tibbs, _Pocket Guide to The world of E1_, 2002, obtido de #link("https://web.archive.org/web/20240429125245/https://web.fe.up.pt/~mleitao/STEL/Tecnico/E1_ACTERNA.pdf")[web.fe.up.pt].]
  ]

  #set text(size: 17pt)
  - *Caso 1:* basta `000V`.
  - *Caso 2:* precisa `B00V` para manter ausência de DC; as violações aparecem *só* onde havia 4 zeros consecutivos.
]

// ============================================================
// SLIDE 24 — Decodificador HDB3 na prática
// ============================================================
#slide[
  == Como o receptor desfaz HDB3

  #align(center)[
    #image("hdb3_fifos.svg", width: 55%)
  ]

  #set text(size: 22pt)
  - O decodificador detecta padrões impossíveis em AMI puro.
  - Se aparecer violação compatível com `000V` ou `B00V`, \ os 4 símbolos viram `0000`.
  - A implementação usa *4 FIFOs* de 1 elemento para ter _look-ahead_ local.
  - Conecta diretamente a teoria do código de linha à arquitetura de hardware.
]

// ============================================================
// SLIDE 25 — Densidade espectral dos códigos de linha
// ============================================================
#slide[
  == Densidade espectral dos códigos de linha

  #align(center)[
    #image("dayan_figure4_2.jpg", width: 40%)
    #v(-0.8em)
    #text(size: 9pt)[Guimarães, _Digital Transmission_, 2009, obtido de #link("https://doi.org/10.1007/978-3-642-01359-1")[doi.org].]
  ]

  #set text(size: 17pt)
  - NRZ unipolar concentra energia em DC. AMI e HDB3 têm nulo em DC.
  - HDB3 *preserva* as vantagens espectrais do AMI e corrige o problema de sequências de zero.
]

// ============================================================
// SLIDE 26 — Por que o E1 escolheu HDB3
// ============================================================
#slide[
  == Por que o E1 escolheu HDB3

  #set text(size: 22pt)
  - Sem DC → compatível com acoplamento por transformador.
  - Máximo de 3 zeros consecutivos → recuperação de clock viável.
  - Violação controlada → ajuda a detectar padrões inválidos.
  - Eficiência espectral melhor que Manchester.
  - Complexidade bem menor que soluções com DSP pesado.

  #v(1em)
  _HDB3 é uma escolha coerente para enlaces PCM a 2,048 Mbit/s em par metálico balanceado._
]

// ============================================================
// SLIDE 27 — Hardware da prática
// ============================================================
#slide[
  #text(size: 19pt, weight: "bold")[Hardware da prática: recepção e transmissão E1]

  #v(0.1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.8em,
    [
      #image("board_schem.svg", width: 92%)
    ],
    [
      #align(center)[
        #image("rx_frontend_waveforms.svg", width: 100%)
      ]
      #v(-1em)
      #set text(size: 15pt)
      - *RX:* dois comparadores detectam pulsos positivos e negativos.
      - *TX:* os próprios pinos do FPGA forçam corrente em um sentido ou no outro.
      - Placa pensada para cabos curtos de bancada, não para enlaces longos.
    ],
  )
]

// ============================================================
// SLIDE 28 — Receptor de laboratório vs comercial
// ============================================================
#slide[
  == Receptor de laboratório vs. receptor comercial

  #set text(size: 19pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 1.2em,
    [
      *Na nossa prática:*
      - Transformador + comparadores
      - Limiar fixo
      - Oversampling + DPLL digital
    ],
    [
      *Em LIUs comerciais de E1:*
      - Equalização / compensação de linha
      - Modos _short-haul_ / _long-haul_
      - _Slicer_ / decisão
      - _Clock-data recovery_
      - _Jitter attenuator_
      - Decodificação de linha
    ],
  )
  
  #v(0.5em)
  _O mercado frequentemente esconde no front-end parte do que nós estamos explicitando didaticamente._
]

// ============================================================
// SLIDE 29 — Detecção de pulso: problema de decisão
// ============================================================
#slide[
  == Detectar um pulso recebido: problema de decisão

  #align(center)[
    #image("dayan_figure4_5.jpg", width: 50%)
    #v(-0.8em)
    #text(size: 10pt)[Guimarães, _Digital Transmission_, 2009, obtido de #link("https://doi.org/10.1007/978-3-642-01359-1")[doi.org].]
  ]

  - Retomando o módulo 1: o receptor ideal quer maximizar a separação entre "pulso presente" e "pulso ausente".
  - O formalismo clássico leva a filtro casado / correlator.
  - No E1 de bancada, o front-end já nos entrega decisões ternárias "digitalizadas".
]

// ============================================================
// SLIDE 30 — Por que limiar simples basta
// ============================================================
#slide[
  == Por que na Prática 2 um limiar simples basta

  #set text(size: 22pt)
  - Cabos curtos, atenuação pequena, forma de onda limpa.
  - Transformador + comparadores comprimem a decisão em três estados: \ *P*, *Z*, *N*.
  - O gargalo didático deixa de ser "como projetar o melhor filtro" e passa a ser:
    - Amostrar no instante certo
    - Reconstruir o clock
    - Entender o código de linha

  #v(0.5em)
  _Por isso a prática concentra esforço em DPLL e HDB3, não em equalização adaptativa._
]

// ============================================================
// SLIDE 31 — Recuperação de temporização
// ============================================================
#slide[
  == Recuperação de temporização: o problema central

  - O transmissor e o receptor têm relógios próprios.
  - Mesmo um erro pequeno de frequência, acumulado ao longo do tempo, desloca o instante ótimo de amostragem.
  - Se o receptor amostrar cedo ou tarde demais:
    - a margem contra ruído cai;
    - o HDB3 pode ser interpretado errado.

  #v(0.5em)
  _Como usar as transições do sinal recebido para corrigir continuamente nosso relógio local?_
]

// ============================================================
// SLIDE 32 — DPLL da Prática 2
// ============================================================
#slide[
  == DPLL da Prática 2: funcionamento

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      #image("dpll.svg", width: 100%)
    ],
    [
      #set text(size: 20pt)
      - Contador roda no clock sobreamostrado.
      - Quando chega a zero → amostragem do símbolo.
      - Ao detectar o início de um pulso, verifica se a borda chegou cedo, no tempo ou tarde.
      - Ajuste aplicado ao próximo período:
        - `max - 1` (borda cedo)
        - `max` (no tempo)
        - `max + 1` (borda tarde)
    ],
  )
]

// ============================================================
// SLIDE 33 — DPLL: detector de fase + NCO
// ============================================================
#slide[
  == Interpretação em blocos: detector de fase + NCO

  - A DPLL implementa um laço de realimentação negativa.
  - Entrada: fase observada das bordas do sinal.
  - Referência interna: fase esperada da borda.
  - Erro de fase → comando discreto $\{-1, 0, +1\}$.
  - Comando → ajuste no período do contador.

  $  "período"_(k+1) = "período"_"nominal" + u_k, quad u_k in \{-1, 0, +1\} $

  #v(0.5em)
  _Não é magia: é uma malha de controle digital extremamente simples._
]

// ============================================================
// SLIDE 34 — Por que o laço converge
// ============================================================
#slide[
  == Por que o laço converge

  #set text(size: 21pt)
  - Borda chega cedo → encurtamos o próximo período.
  - Borda chega tarde → alongamos o próximo período.
  - Correção sempre no sentido *oposto* ao erro → *realimentação negativa*.
  
  Modelo discreto útil:

  $ e_(k+1) approx e_k + K epsilon - u_k $

  - $e_k$: erro de fase acumulado
  - $epsilon$: erro fracionário entre os clocks
  - $K$: intervalos de bit até a próxima transição útil
  - Em regime travado, o erro oscila dentro de uma faixa pequena imposta pela quantização do oversampling.
]

// ============================================================
// SLIDE 35 — Oversampling
// ============================================================
#slide[
  == Oversampling: o que ele proporciona

  #set text(size: 22pt)
  - Mais oversampling = maior resolução temporal.
  - Maior resolução = detector de fase menos grosseiro.
  - Menor erro residual de quantização.
  - Mais margem para jitter e pequenas diferenças entre clocks.

  #v(0.5em)
  - Mínimo conceitual: ~4 amostras por bit.
  - Na prática, *16×* ou *32×* dão um laço muito mais estável.

  #v(0.5em)
  _O mínimo teórico e o mínimo confortável não são a mesma coisa._
]

// ============================================================
// SLIDE 36 — Limites teóricos da DPLL + HDB3
// ============================================================
#slide[
  == Limites teóricos desta DPLL em HDB3

  #set text(size: 21pt)
  - A DPLL só corrige quando há transição observável.
  - HDB3 garante no máximo *3 zeros consecutivos*.
  - Na pior hipótese: máximo de *4 intervalos de bit* sem oportunidade de correção.

  $ |epsilon|_max approx 1/(K dot M) $
  
  - $K lt.eq 4$: pior espaçamento entre transições
  - $M$: fator de oversampling

  Para $M = 32$: $|epsilon|_max approx 1/128 approx 0,78%$

  #v(0.3em)
  _Código de linha e clock recovery não podem ser ensinados separadamente._
]

// ============================================================
// SLIDE 37 — Diagrama de olho
// ============================================================
#slide[
  == Diagrama de olho aplicado ao E1

  #align(center)[
    #image("dayan_figure4_33.png", width: 55%)
    #v(-0.5em)
    #text(size: 10pt)[Guimarães, _Digital Transmission_, 2009, obtido de #link("https://doi.org/10.1007/978-3-642-01359-1")[doi.org].]
  ]

  #set text(size: 20pt)
  - Instante ótimo de amostragem = máxima abertura vertical do olho.
  - Fechamento vertical: ruído e ISI. Fechamento horizontal: jitter.
  - A DPLL mantém a amostragem no centro da abertura.
]

// ============================================================
// SLIDE 38 — Comutação por circuitos vs. pacotes
// ============================================================
#slide[
  == Comutação por circuitos vs. comutação por pacotes

  #set text(size: 22pt)
  - Telefonia clássica: rede comutada por *circuitos*.
  - IP: rede comutada por *pacotes*.
  - O E1 foi concebido no mundo da comutação por circuitos.
  - Na Prática 2, colocamos quadros HDLC com tráfego IP dentro de um \ enlace E1.

  #v(0.5em)
  _A prática é uma instância concreta de "pacotes sobre infraestrutura historicamente pensada para circuitos"._

  #v(0.3em)
  _O dual também existe: redes de pacotes podem emular circuitos virtuais._
]

// ============================================================
// SLIDE 39 — HDLC: papel na cadeia
// ============================================================
#slide[
  == HDLC: papel na cadeia

  #set text(size: 19pt)

  - Depois de recuperar bits e timeslots, ainda falta *delimitar quadros*.
  - Esse é o papel do HDLC.
  - No nosso pipeline:
    - `E1Unframer` descobre o canal.
    - `HDLCUnframer` descobre o pacote.
  - Sem HDLC, teríamos apenas um fluxo síncrono contínuo de bits, sem fronteiras.

  - *Flag HDLC:* `01111110`; em ocioso, transmite-se uma sequência contínua de flags.
  - Um quadro começa depois de uma flag e termina antes da próxima.
]

// ============================================================
// SLIDE 40 — Bit stuffing
// ============================================================
#slide[
  == Bit stuffing: transparência orientada a bit

  #align(center)[
    #image("bit_stuffing.svg", width: 68%)
  ]

  #set text(size: 20pt)
  - Após cinco 1s consecutivos no payload, *inserir um 0*.
  - No receptor: se vier `111110`, descartar o 0.
  - Resultado: a sequência de flag *nunca* aparece acidentalmente dentro do conteúdo.
]

// ============================================================
// SLIDE 41 — Da flag ao ping: HDLC → cHDLC → IPv4 → ICMP
// ============================================================
#slide[
  == Da flag ao ping

  #set text(size: 20pt)
  - Após o desembrulho HDLC, o payload é um quadro *cHDLC* contendo um datagrama IPv4 com ICMP Echo.
  - O `ICMPReplier` é um datapath mínimo, capaz de:
    - reconhecer ICMP Echo Request
    - trocar endereços
    - recalcular checksums
    - anexar FCS (Frame Check Sequence)
  - Teste concreto: *ping no Cisco → resposta na FPGA*.
]

// ============================================================
// SLIDE 42 — Detecção de erros: por que CRC
// ============================================================
#slide[
  == Detecção de erros: por que o CRC

  #set text(size: 22pt)
  - Quadros podem ser corrompidos na linha.
  - Paridade simples não basta --- queremos detecção com probabilidade altíssima e custo mínimo em hardware.
  - Esse é exatamente o nicho do *CRC*.

  #v(0.5em)
  *Mensagem como polinômio sobre GF(2)*

  - Em vez de pensar a mensagem como um inteiro, pensamos como um polinômio em $x$.
  - Exemplo: `01001000` → $x^6 + x^3$.
  - Cada bit 1 vira um termo. Grande vantagem: *não há carry entre posições*.
]

// ============================================================
// SLIDE 43 — GF(2): soma e subtração viram XOR
// ============================================================
#slide[
  == GF(2): soma e subtração viram XOR

  No CRC trabalhamos em GF(2): coeficientes são 0 ou 1.

  #align(center)[
    #text(size: 28pt)[
      $1 + 1 = 0 quad quad 1 - 1 = 0 quad quad 1 + 0 = 1$
    ]
  ]

  #v(0.5em)
  - Subtrair um polinômio equivale a somar, que equivale a *XOR* termo a termo.

  #v(0.5em)
  _É isso que torna a divisão polinomial implementável com portas XOR e registradores._
]

// ============================================================
// SLIDE 44 — Divisão polinomial: passo a passo
// ============================================================
#slide[
  == Divisão polinomial: passo a passo

  #align(center)[
    #image("poly_div.svg", width: 34%)
  ]

  #set text(size: 19pt)
  - Transmitir = anexar o resto de $M(x) dot x^r div G(x)$.
  - Receber = dividir o quadro inteiro por $G(x)$.
  - *Resto zero → quadro consistente.*
]

// ============================================================
// SLIDE 45 — LFSR: CRC em hardware
// ============================================================
#slide[
  == Por que CRC é amigável para FPGA

  #align(center)[
    #image("lfsr_crc.svg", width: 64%)
  ]

  #set text(size: 20pt)
  - A divisão polinomial em GF(2) pode ser implementada como *LFSR*.
  - Cada bit de entrada avança o registrador.
  - Os taps do polinômio viram XORs.
  - Sem multiplicadores, sem divisores gerais.
]

// ============================================================
// SLIDE 46 — Capacidade de detecção do CRC
// ============================================================
#slide[
  == Capacidade de detecção do CRC

  #set text(size: 21pt)
  - Todo CRC *bem escolhido* detecta todos os erros de 1 bit.
  - Detecta todos os _bursts_ com comprimento $lt.eq$ grau do polinômio.
  - Para erros mais longos, importam os fatores do polinômio.

  #v(0.5em)
  - Na nossa prática (HDLC): *CRC-16-CCITT* ($x^16 + x^12 + x^5 + 1$).
  - CRC-32 aparecerá no módulo 3, ao estudar Ethernet.

  #v(0.5em)
  #text(size: 18pt)[_Se o gerador tem grau $r$, um burst de comprimento $L lt.eq r$ não pode ser múltiplo exato de $G(x)$, portanto é sempre detectado._]
]

// ============================================================
// SLIDE 47 — Mapa do quadro E1
// ============================================================
#slide[
  == Mapa do quadro E1: voz, sinalização e dados

  #set text(size: 19pt)
  - *TS0* → sincronismo, alarmes, eventualmente CRC-4.
  - *TS16* → sinalização CAS (ABCD).
  - *TS1--15 e TS17--31* → 30 canais de 64 kbit/s.

  Na telefonia clássica, convém separar três planos:
  - *Sinalização de assinante/acústica* → telefone ↔ central
  - *Sinalização de linha* → supervisão entre terminações do tronco (vai em TS16 no E1/CAS)
  - *Sinalização de registro* → dígitos, categoria e controle (pode ir in-band, como no R2/MFC)

  #v(0.3em)
  #text(size: 17pt)[_Num assinante analógico, o telefone não escreve TS16 diretamente --- a central converte o estado local nos bits ABCD. Num tronco E1 empresarial, o PABX gera/interpreta os bits ABCD._]
]

// ============================================================
// SLIDE 48 — E&M: o que é
// ============================================================
#slide[
  == E&M: sinalização de linha para troncos

  #set text(size: 18pt)
  - E&M é uma família de sinalizações de linha para troncos telefônicos.
  - Função: supervisionar o tronco --- *livre*, *ocupação*, *atendimento*, *desligamento*.
  - E&M *não define*, por si só, como os dígitos são enviados.

  #v(0.5em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      *Exemplo Cisco E&M digital:*
      - _idle/on-hook_ = `ABCD 0000`
      - _seized/off-hook_ = `ABCD 1111`
    ],
    [
      #image("E1_acterna_figure10.svg", width: 88%)
      #v(-0.8em)
      #text(size: 9pt)[Tibbs, _Pocket Guide to The world of E1_, 2002, obtido de #link("https://web.archive.org/web/20240429125245/https://web.fe.up.pt/~mleitao/STEL/Tecnico/E1_ACTERNA.pdf")[web.fe.up.pt].]
    ],
  )
]

// ============================================================
// SLIDE 49 — E&M: caso típico de tie-line
// ============================================================
#slide[
  == E&M: caso típico de tie-line entre PABXs

  #grid(
    columns: (1fr, 1fr),
    gutter: 0.9em,
    [
      #set text(size: 16pt)
      + Tronco em _idle_.
      + Origem faz _seizure_ do tronco.
      + Em variantes _wink_, o destino devolve \ pulso curto = "estou pronto".
      + Caminho de áudio é aberto; usuário ouve tom de discar remoto.
      + Usuário envia dígitos do destino \ (DTMF pelo tronco tomado).
      + Equipamento remoto roteia a chamada.
      + Destino atende → conversa pelo tronco.
      + Desligamento → tronco volta a _idle_.
    ],
    [
      #align(center)[
        #image("em_signalling_diagram.svg", width: 92%)
        #v(-0.2em)
        #text(size: 9pt)[Cisco, _Understanding How Digital T1 CAS Works in IOS Gateways_, 2007, obtido de #link("https://www.cisco.com/c/en/us/support/docs/voice/digital-cas/22444-t1-cas-ios.html")[cisco.com].]
      ]
    ],
  )
  #v(0.3em)
  #text(size: 15pt)[_A supervisão é simples; o restante da chamada acontece do lado remoto após a abertura do caminho de áudio._]
]

// ============================================================
// SLIDE 50 — R2/MFC: sinalização em dois planos
// ============================================================
#slide[
  == R2/MFC: sinalização em dois planos no mesmo E1

  #set text(size: 20pt)
  - Na sinalização R2, há *dois planos*:
    - *Sinalização de linha* (_line signaling_) → bits ABCD em TS16
    - *Sinalização de registradores* (_inter-register signaling_) → tons multifrequenciais no próprio canal de voz
  - R2/MFC foi a sinalização predominante em troncos digitais E1 no Brasil.
  - MFC é *compelida*: cada sinal para a frente espera um sinal de volta antes do próximo passo.

  #v(0.5em)
  _No R2/MFC, o mesmo timeslot que depois carregará PCM de voz é temporariamente usado para sinalização de registradores._
]

// ============================================================
// SLIDE 51 — R2 digital: bits A/B por fase da chamada
// ============================================================
#slide[
  == R2 digital: bits A/B por fase da chamada

  #set text(size: 16.5pt)
  #table(
    columns: (1.5fr, 1fr, 1fr, 1.5fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Fase*], [*Orig→Dest* (af bf)], [*Dest→Orig* (ab bb)], [*Interpretação*]),
    [Tronco livre],    [`1 0`],          [`1 0`],          [_idle_],
    [Ocupação],        [`0 0`],          [`1 0`],          [origem toma o circuito],
    [Em progresso],    [`0 0`],          [`1 1`],          [destino confirmou; MFC pode começar],
    [Atendimento],     [`0 0`],          [`0 1`],          [chamada atendida],
    [Conversação],     [`0 0`],          [`0 1`],          [canal carrega PCM de voz],
    [Deslig. p/ trás], [`0 0`],          [`1 1`],          [destino iniciou liberação],
    [Deslig. p/ frente], [`1 0`],        [`X 1`],          [origem iniciou liberação],
    [Confirmação],     [`1 0`],          [`1 0`],          [tronco volta a _idle_],
  )

  #text(size: 15pt)[_No R2 digital internacional (Q.421), a supervisão usa só A e B; C fica fixo em 0 e D em 1._]
]

// ============================================================
// SLIDE 52 — R2/MFC: diálogo compelido
// ============================================================
#slide[
  == R2/MFC: diálogo compelido entre registradores

  #set text(size: 20pt)
  MFC não é "mandar dígitos" --- é um *diálogo compelido*.

  Exemplo compacto:
  + Origem envia sinal _forward_ (dígito).
  + Destino responde A1 = "envie o próximo dígito".
  + Após alguns dígitos, destino responde A3 = "mude para outro grupo".
  + Origem envia G2 = "categoria do chamador".
  + Destino responde B1 = "assinante livre com tarifação".

  #v(0.5em)
  - Sinais _forward_ = frequências altas; sinais _backward_ = frequências baixas.
  - Durante a fase MFC, o tronco está ligado ao bloco de registradores, *não ao usuário*.
]

// ============================================================
// SLIDE 53 — DTMF, pulso decádico e MFC
// ============================================================
#slide[
  == DTMF, pulso decádico e MFC: quem é in-band?

  #set text(size: 18pt)
  #table(
    columns: (1fr, 1.5fr, 1.5fr),
    inset: 6pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Mecanismo*], [*Natureza*], [*No E1*]),
    [DTMF], [Tons na faixa de voz], [Pode atravessar a banda de áudio do tronco],
    [Pulso decádico], [Abertura/fechamento do loop no acesso analógico], [Convertido em CAS/ABCD no TS16 pelo gateway],
    [MFC / MFC-R2], [Tons multifrequenciais na faixa de voz], [In-band no canal de tráfego entre centrais],
  )

  #v(0.5em)
  _Nem todo mecanismo de discagem usa o canal de voz: DTMF e MFC usam banda de voz; pulso decádico, ao ser transportado por E1/CAS, vira sinalização no TS16._
]

// ============================================================
// SLIDE 54 — Da telefonia CAS ao SIP
// ============================================================
#slide[
  == Da telefonia CAS ao SIP: panorama evolutivo

  #set text(size: 20pt)
  #table(
    columns: (1fr, 1.2fr, 1.5fr),
    inset: 6pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Época*], [*Tecnologia*], [*Onde anda a sinalização*]),
    [~1960s], [E&M / troncos analógicos], [Corrente e tensão nos fios],
    [~1970s], [E1 CAS / R2-MFC], [TS16 + tons no canal de voz],
    [~1980s], [SS7 / TUP / ISUP], [Canal comum separado (CCS)],
    [~2000s], [SIP / VoIP], [Mensagens em rede de pacotes],
  )

  #v(0.5em)
  Analogia: _seizure_ ~ `INVITE`, _ringing_ ~ `180 Ringing`, _ answer_ ~ `200 OK`, _clear_ ~ `BYE`.

  #text(size: 16pt)[_Este slide é panorâmico; os detalhes de VoIP ficam fora deste módulo._]
]

// ============================================================
// SLIDE 55 — Conexão com equipamentos de mercado
// ============================================================
#slide[
  == Conexão com equipamentos de mercado

  #set text(size: 21pt)
  - Gateways e roteadores com interfaces E1 permitem fracionar timeslots entre voz e dados.
  - O conceito importante: o equipamento real precisa:
    - terminar a física E1
    - interpretar _line code_ e _frame_
    - fracionar timeslots
    - encaminhar voz e/ou dados
  - Padrões CAS/ABCD de _idle_, _seize_ etc. são configuráveis por equipamento.

  #v(0.3em)
  _Isso reforça por que vale separar a lógica da sinalização do mapeamento específico de bits._
]

// ============================================================
// SLIDE 56 — BSV: o mínimo para ler a prática
// ============================================================
#slide[
  == BSV: o mínimo para ler a prática

  #set text(size: 20pt)
  - BSV = Bluespec SystemVerilog (HDL com abstrações de alto nível).
  - Três conceitos-chave:
    - *Módulos:* unidades de hardware com estado.
    - *Interfaces:* portas tipadas (Put/Get).
    - *Regras:* ações automáticas quando a guarda está satisfeita.

  #v(0.4em)
  #box(
    fill: rgb("#f6f7fb"),
    stroke: 0.6pt + rgb("#d7dbe8"),
    inset: 10pt,
    radius: 6pt,
  )[
    #set text(font: "DejaVu Sans Mono", size: 14pt)
    #stack(
      spacing: 0.15em,
      [#text(fill: rgb("#2b5fad"), weight: "bold")[interface] #raw("HDB3Decoder;", lang: none)],
      [#pad(left: 1.6em)[#text(fill: rgb("#2b5fad"), weight: "bold")[interface] #raw("Put#(Symbol) in;", lang: none)]],
      [#pad(left: 1.6em)[#text(fill: rgb("#2b5fad"), weight: "bold")[interface] #raw("Get#(Bit#(1)) out;", lang: none)]],
      [#text(fill: rgb("#2b5fad"), weight: "bold")[endinterface]],
    )
  ]
]

// ============================================================
// SLIDE 57 — BSV: regras, FIFOs e composição
// ============================================================
#slide[
  == BSV: regras, FIFOs e composição

  #set text(size: 18pt)
  - `rule`: ação automática quando a guarda está satisfeita.
  - `FIFOF`: forma comum de desacoplar estágios.
  - `mkConnection`: conecta interfaces sem cola manual.

  #v(0.3em)
  #box(
    fill: rgb("#f6f7fb"),
    stroke: 0.6pt + rgb("#d7dbe8"),
    inset: 10pt,
    radius: 6pt,
  )[
    #set text(font: "DejaVu Sans Mono", size: 13.5pt)
    #stack(
      spacing: 0.15em,
      [#text(fill: rgb("#2b5fad"), weight: "bold")[rule] #raw("select_desired_ts;", lang: none)],
      [#pad(left: 1.6em)[#text(fill: rgb("#2b5fad"), weight: "bold")[match] #raw("{.ts, .value} <- unfr.out.get;", lang: none)]],
      [#pad(left: 1.6em)[#text(fill: rgb("#2b5fad"), weight: "bold")[if] #raw("(ts != 0) unhdlc.in.put(value);", lang: none)]],
      [#text(fill: rgb("#2b5fad"), weight: "bold")[endrule]],
    )
  ]
  #v(0.2em)
  #box(
    fill: rgb("#f6f7fb"),
    stroke: 0.6pt + rgb("#d7dbe8"),
    inset: 10pt,
    radius: 6pt,
  )[
    #set text(font: "DejaVu Sans Mono", size: 13.5pt)
    #stack(
      spacing: 0.15em,
      [#text(fill: rgb("#0b6e4f"))[mkConnection]#raw("(hdb3enc.out, tlio.in);", lang: none)],
      [#text(fill: rgb("#0b6e4f"))[mkConnection]#raw("(tlio.out, hdb3dec.in);", lang: none)],
    )
  ]

  #v(0.3em)
  _A arquitetura da prática é essencialmente "encanamento síncrono" entre blocos._
]

// ============================================================
// SLIDE 58 — Mapa mental para a prática
// ============================================================
#slide[
  == Mapa mental para entrar na prática

  #set text(size: 21pt)
  - *Física do enlace:* G.703, pulso, HDB3, comparadores.
  - *Temporização:* oversampling + DPLL.
  - *Estrutura E1:* quadros, TS0, TS16, sincronismo.
  - *Enlace de dados:* HDLC + bit stuffing.
  - *Detecção de erros:* CRC.
  - *Telefonia clássica:* voz PCM + sinalização CAS / E&M / R2.
  - *Implementação:* blocos em BSV conectados por FIFOs e regras.

  #v(0.5em)
  _Se o aluno entende esse mapa, a Prática 2 deixa de ser "um monte de arquivos" e vira um sistema de comunicação coerente._
]
