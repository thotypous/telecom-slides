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

    Módulo 3 -- Ethernet: meio físico, endereçamento, \
    controle de acesso ao meio (MAC) e camadas físicas (PHYs)

    #text(size: 18pt)[Da Ethernet clássica às PHYs modernas]

    Prof. Paulo Matias
  ]
]

// ============================================================
// SLIDE 2 — Objetivos
// ============================================================
#slide[
  == Objetivos deste módulo

  #set text(size: 18pt)

  Ao fim desta aula, o aluno deve saber responder:

  - Por que Ethernet nasceu com CSMA/CD (_Carrier Sense Multiple Access with Collision Detection_) e por que isso quase desapareceu?
  - Como MAC, preâmbulo, SFD (_Start Frame Delimiter_), FCS (_Frame Check Sequence_) e tamanho mínimo se encaixam?
  - Como implementar uma PHY 10BASE-T simples em FPGA (_Field-Programmable Gate Array_)?
  - Por que 100BASE-TX, 1000BASE-T e 10GBASE-T exigem blocos cada vez mais sofisticados?
  - Como PHYs ópticas modernas escalam até 100G e além?

  #v(0.5em)
  #text(size: 14.5pt)[_Ethernet não é só formato de quadro: envolve física, temporização, acesso ao meio e compatibilidade._]
]

// ============================================================
// SLIDE 3 — E1 vs Ethernet
// ============================================================
#slide[
  == Do E1 ao Ethernet: mudança de paradigma

  #set text(size: 13pt)
  #table(
    columns: (1.1fr, 1.85fr, 2fr),
    inset: 3pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Aspecto*], [*E1 / PDH* (_Plesiochronous Digital Hierarchy_)], [*Ethernet*]),
    [Origem], [telefonia digital, voz PCM], [redes locais de computadores],
    [Multiplexação], [TDM (_Time-Division Multiplexing_) rígido: timeslots fixos], [pacotes: ocupação sob demanda],
    [Unidade básica], [canal de 64 kbit/s], [quadro Ethernet variável],
    [Sincronismo], [fluxo contínuo; alinhamento mantido pela rede], [10BASE-T: clock recovery por quadro via preâmbulo; PHYs modernas: CDR (_Clock and Data Recovery_) pode travar no idle contínuo],
    [Acesso ao meio], [circuito ou timeslot previamente alocado], [meio compartilhado com CSMA/CD; depois switches],
    [Endereçamento], [posição no quadro/circuito], [endereço MAC no próprio quadro],
    [Erro], [códigos de linha, alarmes, CRC (_Cyclic Redundancy Check_) opcional], [FCS CRC-32 por quadro],
  )

  #v(0.15em)
  #text(size: 10.8pt)[_No E1: timeslot e quadro contínuo. No Ethernet clássico: começo do quadro, preâmbulo, acesso ao meio e MAC de destino._]
]

// ============================================================
// SLIDE 4 — Visão de sistema da prática
// ============================================================
#slide[
  == Pipeline da Prática 3: visão de sistema

  #set text(size: 16pt)
  #text(size: 12pt)[RJ45 é o conector modular do enlace; AFE (_Analog Front-End_) é a frente analógica; ARP (_Address Resolution Protocol_) é a aplicação mínima; NLP (_Normal Link Pulse_) mantém indicação de enlace; TX é transmissão.]
  #v(0.2em)
  #align(center)[
    #fletcher.diagram(
      spacing: (0.58em, 1.55em),
      node-stroke: 0.8pt,
      edge-stroke: 0.8pt,
      node((0,0), [RJ45\ + magnetics]), edge("-|>"),
      node((1,0), [AFE\ discreto], shape: fletcher.shapes.pill), edge("-|>"),
      node((2,0), [Frame\ Delimiter], shape: fletcher.shapes.pill), edge("-|>"),
      node((3,0), [Manchester\ Decoder], shape: fletcher.shapes.pill), edge("-|>"),
      node((4,0), [SFD\ Locator], shape: fletcher.shapes.pill), edge("-|>"),
      node((5,0), [ARP\ Detector], shape: fletcher.shapes.pill),
      edge((5,0), (5,1), "-|>"),
      node((5,1), [ARP\ Reply], shape: fletcher.shapes.pill), edge("-|>"),
      node((4,1), [CRC-32\ + MAC], shape: fletcher.shapes.pill), edge("-|>"),
      node((3,1), [Manchester\ Encoder], shape: fletcher.shapes.pill), edge("-|>"),
      node((2,1), [CSMA/CD\ + NLP], shape: fletcher.shapes.pill), edge("-|>"),
      node((1,1), [TX\ diferencial], shape: fletcher.shapes.pill), edge("-|>"),
      node((0,1), [RJ45]),
    )
  ]

  #v(0.4em)
  #set text(size: 19pt)
  - O recorte é 10BASE-T half duplex: antigo o suficiente para abrir a caixa-preta.
  - O restante do módulo mostra como a mesma arquitetura cresceu até PHYs modernas.
]

// ============================================================
// SLIDE 5 — Linha do tempo
// ============================================================
#slide[
  == Linha do tempo: uma mesma MAC, muitas PHYs

  #set text(size: 14.2pt)
  #table(
    columns: (0.8fr, 1.45fr, 2.2fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Ano*], [*Tecnologia*], [*Ideia dominante*]),
    [1973], [Ethernet experimental], [meio compartilhado inspirado em ALOHA],
    [1985], [10BASE5 / 10BASE2], [coaxial em barramento, CSMA/CD],
    [1990], [10BASE-T], [par trançado, estrela física, hub lógico],
    [1995], [100BASE-TX / FX], [4B/5B, MLT-3 (_Multi-Level Transmit_, 3 níveis), fibra],
    [1998--1999], [1000BASE-X / T], [8B/10B; DSP (_Digital Signal Processing_) e PAM5 (5 níveis)],
    [2002], [10GbE (_10 Gigabit Ethernet_)], [full duplex, 64B/66B, WDM (_divisão por λ_)],
    [2006+], [10GBASE-T], [PAM16, FEC (_Forward Error Correction_), canceladores],
    [2010+], [40G/100G/400G+], [lanes paralelas, PAM4 (4 níveis) e FEC],
  )
]

// ============================================================
// SLIDE 6 — Separação MAC/PHY
// ============================================================
#slide[
  == Ideia central: separar MAC e PHY

  #set text(size: 17pt)

  #grid(
    columns: (1.05fr, 1fr),
    gutter: 1em,
    [
      - A *MAC* define quadro, endereços, FCS, regras de transmissão e recepção.
      - A *PHY* transforma bits em sinais no meio físico e sinais em bits.
      - Interfaces como AUI, MII, GMII, XGMII, XAUI e SerDes preservam essa separação.
      - Por isso Ethernet pôde trocar coaxial por UTP, fibra, backplane e DAC sem trocar o modelo de quadro.
    ],
    [
      // Figura: diagrama em blocos mostrando a camada MAC como um bloco horizontal comum no topo. Abaixo dela há várias PHYs Ethernet em colunas verticais, incluindo 10Base-T, 100Base-T4, 100Base-T2, 100BASE-TX, 1000BASE-T, FOIRL, 10BASE-F, 100BASE-FX, 1000BASE-SX e 1000BASE-LX. Na base, essas PHYs se conectam a meios físicos diferentes: Cat-3, Cat-5, fibra multimodo e fibra monomodo. A figura enfatiza que a mesma MAC permanece acima de várias camadas físicas e meios de transmissão.
      #align(center)[
        #image("fig/eth_phy_stack_mac_media.png", width: 100%)
        #v(-0.6em)
        #text(size: 8pt)[Spurgeon, _Ethernet: The Definitive Guide_, em UNH IOL, _Ethernet Evolution From 10 Meg to 10 Gig_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/ethernet/ethernet_evolution.pdf")[iol.unh.edu].]
      ]
    ],
  )

  #v(0.2em)
  #text(size: 13pt)[_A compatibilidade de longo prazo vem de manter estável o contrato entre as camadas._]
]

// ============================================================
// SLIDE 7 — Subcamadas da PHY
// ============================================================
#slide[
  == Dentro da PHY: PCS, PMA, PMD e MDI

  #set text(size: 20pt)
  #table(
    columns: (0.9fr, 2.8fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Bloco*], [*Papel de implementação*]),
    [PCS], [Physical Coding Sublayer: codifica bits da MAC em símbolos, insere controle, faz scrambling/FEC quando aplicável.],
    [PMA], [Physical Medium Attachment: SerDes, CDR, alinhamento de bits/lanes e interface entre símbolos digitais e o PMD.],
    [PMD], [Physical Medium Dependent: parte específica do meio; driver, receptor, laser, fotodiodo, equalização analógica, detecção de sinal.],
    [MDI], [Medium Dependent Interface: o conector físico e sinais no cabo/fibra, como RJ45, par diferencial ou porta óptica.],
  )

  #v(0.5em)
  #text(size: 14.7pt)[_Interfaces como AUI, MII, GMII e XGMII definem onde a MAC conversa com a PHY. PCS/PMA/PMD: codificar, serializar/recuperar clock e adaptar ao meio físico._]
]

// ============================================================
// SLIDE 8 — Alto ALOHA Network
// ============================================================
#slide[
  == De ALOHA para Ethernet

  #set text(size: 20pt)
  #grid(
    columns: (1fr, 1.05fr),
    gutter: 1em,
    [
      - No Xerox PARC, a primeira rede experimental ligava estações Alto a servidores e impressoras.
      - O nome original era *Alto Aloha Network*.
      - A inovação foi evoluir de "transmitir quando quiser" para escutar o meio e detectar colisões.
      - O "ether" era o cabo compartilhado: todos ouviam o mesmo sinal.
    ],
    [
      // Figura: desenho histórico de Bob Metcalfe em fundo de papel envelhecido. Um cabo amarelo grosso identificado como "THE ETHER" percorre a base e sobe pela esquerda. Vários taps conectam pequenas estações ao cabo compartilhado. No alto há um tap ligado a um transceiver, que por sua vez se conecta por um "interface cable" a uma estação com controlador de interface. Na extremidade direita do cabo aparece um terminador. A composição ilustra a Ethernet original como barramento comum com derivações para cada estação.
      #align(center)[
        #image("fig/eth_metcalfe_original.png", width: 100%)
        #v(-0.6em)
        #text(size: 8pt)[Metcalfe, desenho original do Ethernet, em UNH IOL, _Ethernet Evolution From 10 Meg to 10 Gig_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/ethernet/ethernet_evolution.pdf")[iol.unh.edu].]
      ]
    ],
  )
]

// ============================================================
// SLIDE 9 — ALOHA
// ============================================================
#slide[
  == Pure ALOHA e Slotted ALOHA

  #set text(size: 15.5pt)
  - *Pure ALOHA:* transmite quando há quadro; colisões ocorrem com sobreposições.
  - Período vulnerável: aproximadamente duas vezes o tempo de quadro.
  - *Slotted ALOHA:* transmite só no começo de slots sincronizados.
  - Período vulnerável cai para um tempo de quadro.

  #v(0.5em)
  #align(center)[
    $ S_"pure" = G e^(-2G) quad quad S_"slotted" = G e^(-G) $
  ]

  #v(0.1em)
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0.5em,
    [
      // Figura: diagrama temporal do Pure ALOHA com cinco usuários A a E em linhas horizontais. Pequenos retângulos aparecem em posições diferentes ao longo do tempo e alguns se sobrepõem, indicando transmissões independentes que podem colidir em um canal compartilhado sem slots.
      #image("fig/eth_aloha_pure_timing.png", width: 100%)
    ],
    [
      // Figura: diagrama de vulnerabilidade do Pure ALOHA. Um quadro sombreado ocupa uma duração t no centro; quadros iniciados antes do começo ou antes do fim desse quadro sombreado são marcados como colisões. A figura mostra que a janela vulnerável total tem duração de aproximadamente dois tempos de quadro.
      #image("fig/eth_aloha_vulnerable.png", width: 100%)
    ],
    [
      // Figura: gráfico de throughput por tempo de quadro em função da carga oferecida G. A curva do Slotted ALOHA sobe até cerca de 0,37 em G igual a 1, enquanto a curva do Pure ALOHA atinge pico menor, perto de 0,18 em G igual a 0,5, mostrando a vantagem dos slots temporais.
      #image("fig/eth_aloha_throughput.png", width: 100%)
    ],
  )
  #align(center)[#text(size: 6pt)[Abramson/Metcalfe, diagramas de ALOHA, em UNH IOL, _Ethernet Evolution From 10 Meg to 10 Gig_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/ethernet/ethernet_evolution.pdf")[iol.unh.edu].]]
]

// ============================================================
// SLIDE 10 — CSMA/CD
// ============================================================
#slide[
  == CSMA/CD: o salto conceitual

  #set text(size: 22pt)
  - *Carrier Sense:* escute antes de falar.
  - *Multiple Access:* todos compartilham o mesmo domínio de colisão.
  - *Collision Detect:* se outra estação falar junto, detecte, force jam e recue.

  #v(0.5em)
  Algoritmo básico:
  + Se o meio está ocioso, transmita.
  + Se está ocupado, espere ficar livre.
  + Se houver colisão, envie jam, escolha backoff e tente novamente.
]

// ============================================================
// SLIDE 11 — Domínio de colisão
// ============================================================
#slide[
  == Por que existe tamanho mínimo de quadro?

  #set text(size: 16pt)
  - A colisão precisa voltar ao transmissor antes que ele termine de transmitir.
  - O pior caso envolve ida até a estação mais distante e volta do distúrbio.
  - Em 10/100 Mb/s, o slot time clássico é *512 bit times*.
  - Quadro Ethernet mínimo: *64 bytes* de MAC frame, do destino ao FCS.

  #align(center)[
    $ 64 " bytes" times 8 = 512 " bit times" $
  ]

  // Figura: sequência de quatro painéis mostrando duas estações nas extremidades de um cabo compartilhado. Primeiro a estação A inicia transmissão; depois a estação B inicia antes de perceber o sinal de A; no painel seguinte os sinais se encontram e aparece uma colisão no meio do cabo; por fim um ruído de colisão retorna até A após o atraso de ida e volta, demonstrando por que o transmissor precisa continuar enviando tempo suficiente para detectar a colisão.
  #align(center)[
    #image("fig/eth_collision_sequence.png", width: 55%)
    #v(-0.6em)
    #text(size: 8pt)[UNH IOL, _Ethernet Evolution From 10 Meg to 10 Gig_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/ethernet/ethernet_evolution.pdf")[iol.unh.edu].]
  ]
]

// ============================================================
// SLIDE 12 — Backoff
// ============================================================
#slide[
  == Backoff exponencial binário

  #set text(size: 22pt)
  Após a $n$-ésima colisão, a estação escolhe:

  #align(center)[$ k in {0, 1, ..., 2^m - 1}, quad m = min(n, 10) $]

  e espera $k$ slots antes de tentar novamente.

  - A janela cresce quando há disputa.
  - A rede não precisa de coordenador central.
  - O custo é latência variável e eficiência pior sob carga alta.
  - Na Prática 3, um LFSR (_Linear Feedback Shift Register_) gera o $k$ de espera.
]

// ============================================================
// SLIDE 13 — Coaxial
// ============================================================
#slide[
  == 10BASE5 e 10BASE2: o barramento físico

  #set text(size: 16pt)
  - Um único cabo coaxial transporta os sinais de todas as estações.
  - O meio é verdadeiramente compartilhado.
  - Terminadores nas extremidades evitam reflexões.
  - Falha de cabo, mau contato ou terminador esquecido derruba o segmento.

  #grid(
    columns: (1fr, 1fr),
    [
      // Figura: fotografia de uma montagem 10BASE5 sobre carpete azul. À esquerda há um equipamento preto; dele sai um cabo AUI cinza com conector D-sub que vai até um transceptor metálico. O transceptor está preso a um cabo coaxial amarelo grosso, vertical na imagem, com LEDs e etiqueta visíveis. A imagem mostra o nó completo: equipamento, cabo AUI, transceptor e barramento coaxial.
      #image("fig/eth_10base5_node.jpg", height: 60%)
    ],
    [
      // Figura: close-up de um vampire tap aberto. A carcaça preta aparece em primeiro plano com furo metálico circular e cavidades internas; ao fundo, desfocado, passa um cabo coaxial amarelo grosso. A imagem destaca o mecanismo que prende o tap ao cabo e alcança o condutor central sem cortar o segmento inteiro.
      #image("fig/eth_vampire_tap.jpg", height: 60%)
    ],
  )
  #v(-1em)
  #align(center)[#text(size: 8pt)[Matt Millman, _10BASE5 Ethernet_, obtido de #link("https://www.mattmillman.com/projects/10base5/")[mattmillman.com].]]
]

// ============================================================
// SLIDE 14 — AUI/MAU
// ============================================================
#slide[
  == AUI e MAU: modularidade antes do RJ45

  #set text(size: 19pt)
  - *MAU* (_Medium Attachment Unit_): transceptor ligado ao meio.
  - *AUI* (_Attachment Unit Interface_): cabo/interface entre MAC e MAU.
  - O mesmo controlador podia usar 10BASE5, 10BASE2, 10BASE-T ou 10BASE-F.
  - A ideia reaparece em módulos ópticos modernos: GBIC (_Gigabit Interface Converter_), SFP (_Small Form-factor Pluggable_) e QSFP (_Quad SFP_).

  #v(-0.5em)
  // Figura: fotografia de duas extremidades de um cabo drop AUI sobre fundo claro. À esquerda há um conector D-sub macho com pinos dourados visíveis; à direita há um conector D-sub fêmea com furos alinhados. Ambos têm carcaças cinza, cabos grossos cinza e parafusos laterais de travamento, mostrando a interface física entre controlador e transceptor externo.
  #align(center)[
    #image("fig/eth_aui_drop.jpg", width: 45%)
    #v(-1em)
    #text(size: 8pt)[Matt Millman, _10BASE5 Ethernet_, obtido de #link("https://www.mattmillman.com/projects/10base5/")[mattmillman.com].]
  ]
]

// ============================================================
// SLIDE 15 — Estrela com hub
// ============================================================
#slide[
  == 10BASE-T: estrela física, barramento lógico

  #set text(size: 16pt)
  - Cada estação tem um enlace ponto-a-ponto até um hub.
  - O hub é um repetidor: restaura e replica sinais para as outras portas.
  - Fisicamente, a falha de um cabo afeta uma estação.
  - Logicamente, com hub half duplex, ainda há um domínio de colisão.
  - A Prática 3 usa exatamente esse modelo para tornar CSMA/CD observável.

  #grid(
    columns: (0.9fr, 1.1fr),
    gutter: 0.8em,
    [
      // Figura: diagrama de topologia em estrela com um hub no centro e estações ao redor. Um trecho vermelho marca falha em um cabo individual, enquanto conexões verdes indicam que o hub isola a falha daquele enlace sem derrubar todo o cabeamento físico.
      #image("fig/eth_star_hub.jpg", width: 100%)
    ],
    [
      // Figura: comparação entre repetidor e switch. À esquerda, vários computadores conectam-se a um repetidor dentro de uma elipse pontilhada chamada domínio de colisão; à direita, computadores conectam-se a um switch em área indicada como full duplex sem colisões. A figura contrasta hub/repetidor como domínio compartilhado e switch como segmentação dos enlaces.
      #image("fig/eth_repeater_switch.jpg", width: 100%)
    ],
  )
  #v(-1em)
  #align(center)[#text(size: 8pt)[UNH IOL, _Ethernet Evolution From 10 Meg to 10 Gig_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/ethernet/ethernet_evolution.pdf")[iol.unh.edu].]]
]

// ============================================================
// SLIDE 16 — Full duplex
// ============================================================
#slide[
  == Full-duplex: quando colisão deixa de existir

  #set text(size: 22pt)
  - Em UTP, TX e RX (recepção) usam pares separados nas PHYs antigas.
  - Com switch, TX e RX simultâneos são esperados.
  - CSMA/CD só faz sentido em meio compartilhado half duplex.
  - IPG (_Inter-Packet Gap_), quadro, endereço e FCS permanecem.

  #v(0.6em)
  #text(size: 19.5pt)[_A Ethernet cotidiana é comutada/full duplex; a clássica explica parâmetros herdados._]
]

// ============================================================
// SLIDE 17 — Quadro
// ============================================================
#slide[
  == Quadro Ethernet

  #set text(size: 14pt)
  #table(
    columns: (1.1fr, 1fr, 2.2fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Campo*], [*Tamanho*], [*Função*]),
    [Preâmbulo], [7 B], [`0x55` repetido; ajuda clock recovery],
    [SFD], [1 B], [`0xD5`; marca fronteira de byte],
    [Destino], [6 B], [endereço MAC de destino],
    [Origem], [6 B], [endereço MAC de origem],
    [Tipo/tamanho], [2 B], [EtherType ou comprimento],
    [Payload + pad], [46--1500 B], [dados e preenchimento mínimo],
    [FCS], [4 B], [CRC-32 do MAC frame],
  )

  // Figura: diagrama horizontal do quadro Ethernet. Da esquerda para a direita aparecem os campos Preâmbulo de 7 bytes, SFD de 1 byte, endereço de destino de 6 bytes, endereço de origem de 6 bytes, Type/Length de 2 bytes, Dados de 0 a 1500 bytes, Pad de 0 a 46 bytes e Checksum/FCS de 4 bytes. Setas inferiores destacam o delimitador de início de quadro e o campo Type/Length.
  #align(center)[
    #image("fig/eth_frame_format.jpg", width: 76%)
    #v(-0.5em)
    #text(size: 8pt)[UNH IOL, _Ethernet Evolution From 10 Meg to 10 Gig_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/ethernet/ethernet_evolution.pdf")[iol.unh.edu].]
  ]
]

// ============================================================
// SLIDE 18 — Ordem de bits
// ============================================================
#slide[
  == Ordem de bits: detalhe que quebra implementações

  #set text(size: 22pt)
  - No meio, cada octeto Ethernet sai *LSB-first* (_Least Significant Bit first_).
  - Escrevemos `0xD5`, mas o fio vê os bits do bit 0 ao bit 7.
  - Na Prática 3, a desserialização desloca o novo bit até formar o byte.
  - Se inverter a ordem, a UART mostra bytes com bits invertidos.

  #v(0.5em)
  #align(center)[`0x55 = 01010101` continua alternado em qualquer direção.]
  #align(center)[`0xD5 = 11010101`, mas no fio sai `10101011`: o SFD é onde a diferença aparece.]
]

// ============================================================
// SLIDE 19 — Endereçamento
// ============================================================
#slide[
  == Endereçamento Ethernet

  #set text(size: 21pt)
  - Endereço MAC tem *48 bits*.
  - Os primeiros 24 bits normalmente identificam o fabricante: *OUI* (_Organizationally Unique Identifier_).
  - Bit menos significativo do primeiro octeto no fio indica individual/grupo.
  - Unicast: uma estação.
  - Multicast: grupo.
  - Broadcast: `ff:ff:ff:ff:ff:ff`.

  #v(0.5em)
  #text(size: 19pt)[Na prática, a FPGA usa MAC local `de:ad:be:ef:ca:fe` e IP `10.1.2.3`.]
]

// ============================================================
// SLIDE 20 — Provocação sobre endereçamento
// ============================================================
#slide[
  == Ethernet ainda precisaria de MAC address?

  #set text(size: 18pt)
  Provocação: em enlaces ponto a ponto full duplex, o endereço MAC parece menos fundamental do que era no barramento compartilhado.

  - No Ethernet clássico, MAC identifica o destinatário no meio compartilhado.
  - Em Ethernet comutada, o switch ainda aprende portas por MAC, mas isso é bridging e compatibilidade, não exigência física do enlace.
  - Projetando do zero, poderíamos imaginar L2 (_Layer 2_) simples e roteamento em L3 (_Layer 3_).
  - Remover MAC quebraria ARP/ND (_descoberta de vizinhança_), bridges, VLANs (_LANs virtuais_), NICs (_placas de rede_) e décadas de protocolos.

  #v(0.2em)
  #text(size: 15.5pt)[_Ethernet moderna carrega parte do passado no cabeçalho: nem tudo que permanece é estritamente necessário para o enlace físico atual._]
]

// ============================================================
// SLIDE 21 — ARP
// ============================================================
#slide[
  == ARP: aplicação mínima para testar o enlace

  #set text(size: 22pt)
  ARP responde: qual MAC possui este IPv4?

  #v(0.4em)
  Na Prática 3:
  - PC (_personal computer_) envia ARP request para `10.1.2.3`.
  - FPGA reconhece EtherType `0x0806`, opcode request e endereço alvo.
  - FPGA copia MAC/IP do emissor.
  - FPGA monta ARP reply com MAC `de:ad:be:ef:ca:fe`.

  #v(0.4em)
  _Não é preciso implementar pilha IP completa para testar RX, TX e CRC._
]

// ============================================================
// SLIDE 22 — CRC-32
// ============================================================
#slide[
  == FCS Ethernet: CRC-32 em hardware

  #set text(size: 17pt)
  - O FCS cobre do MAC de destino até payload/pad.
  - Não inclui preâmbulo nem SFD.
  - *Bits refletidos*: cada byte entra no cálculo LSB-first, na ordem serial da Ethernet.
  - O FCS também é enviado LSB-first.
  - Polinômio IEEE normal: `0x04c11db7`, usado na descrição MSB-first.
  - *Polinômio refletido*: mesma CRC, mas com taps espelhados para LFSR LSB-first: `0xedb88320`.
  - Implementação natural: LFSR + XORs (_exclusive OR_) em GF(2).

  #align(center)[
    #text(size: 18pt)[Na prática: inicial `0xffffffff`, atualizar com bits refletidos, complemento final.]
  ]
]

// ============================================================
// SLIDE 23 — 10BASE-T forma de onda
// ============================================================
#slide[
  == 10BASE-T: forma de onda Manchester

  #set text(size: 17pt)
  #grid(
    columns: (1fr, 1.25fr),
    gutter: 1em,
    [
      - Taxa de dados: *10 Mbit/s*.
      - Tempo de bit: *100 ns*.
      - Há uma transição obrigatória no meio de cada bit.
      - Convenção da prática: `0 -> 1` no meio representa 1; `1 -> 0` representa 0.
      - Pode haver transição extra na fronteira entre bits iguais.
    ],
    [
      // Figura: forma de onda Manchester em azul, dividida por linhas verticais pretas que marcam fronteiras de bit. Na base há a sequência 1 0 1 0 1 1 1 0 0 0, com um intervalo de 100 ns por bit. A onda tem transição no meio de cada intervalo, permitindo recuperar temporização e dado a partir das mudanças de nível.
      #align(center)[
        #image("fig/eth_manchester_100ns.png", width: 74%)
      ]
      #align(center)[#text(size: 6pt)[UNH IOL, _Ethernet Evolution From 10 Meg to 10 Gig_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/ethernet/ethernet_evolution.pdf")[iol.unh.edu].]]
    ],
  )
]

// ============================================================
// SLIDE 24 — Manchester RX
// ============================================================
#slide[
  == Receptor Manchester: o que implementar

  #set text(size: 22pt)
  Blocos mínimos:
  - _Slicer_ diferencial: converte tensão diferencial em bit amostrado.
  - Detector de atividade: distingue quadro de silêncio/pulsos de link.
  - Recuperação de fase: usa transições para manter contador alinhado.
  - Decodificador: transição central vira bit; transição de fronteira não vira bit.
  - Detector de fim: ausência prolongada de atividade encerra o quadro.

  #v(0.4em)
  _Manchester troca banda por simplicidade de clock recovery._
]

// ============================================================
// SLIDE 25 — AFE prática
// ============================================================
#slide[
  == AFE discreto da Prática 3

  #set text(size: 20pt)
  - RJ45 com magnetics: isolação galvânica e acoplamento capacitivo.
  - TX: pinos LVCMOS (_Low-Voltage Complementary MOS_) complementares, resistores série e transformador.
  - RX: transformador, bias, resistores e LVDS (_Low-Voltage Differential Signaling_).
  - O FPGA enxerga um bit lógico; a física real está no AFE.

  // Figura: esquema elétrico da interface física Ethernet. À direita há um conector J1, modelo RJ45 Hanrun HR911105A Horizontal, com componentes magnéticos e LEDs integrados. Na parte superior, o caminho de transmissão mostra os sinais ETH_TX_P pino 49 e ETH_TX_N pino 48 chegando pela esquerda, passando por resistores série de 12 ohms e entrando nos pinos 1 e 2 do transformador de transmissão do RJ45. Na parte inferior, o caminho de recepção mostra o par de sinais saindo dos pinos 3 e 6 do transformador do RJ45, passando por resistores série de 22 ohms para disponibilizar os sinais ETH_RX_P pino 31 e ETH_RX_N pino 32. Estes sinais de recepção recebem polarização DC através de resistores de 33 ohms conectados a uma linha central de bias. À extrema esquerda, o circuito gerador de bias é composto por um divisor de tensão com um resistor de 1,5k ohms ligado à alimentação de 3,3V e um resistor de 3k ohms ligado ao terra, possuindo um capacitor polarizado de 1 microfarad em paralelo com o resistor de 1,5k ohms. A tensão gerada por este divisor alimenta os resistores de 33 ohms e também segue diretamente para o pino 5, que é a tomada central do transformador de recepção do RJ45.
  #align(center)[
    #image("fig/pratica_circuito.svg", width: 70%)
  ]
]

// ============================================================
// SLIDE 26 — Link pulses
// ============================================================
#slide[
  == Normal Link Pulses

  #set text(size: 24pt)
  #grid(
    columns: (1.25fr, 1fr),
    gutter: 1em,
    [
      - Entre quadros, 10BASE-T não envia idle contínuo.
      - A presença de enlace é indicada por pulsos isolados.
      - Pulso típico: ordem de *100 ns*.
      - Período típico: ordem de *16 ms*.
      - A prática gera NLPs quando não há quadro a transmitir.
    ],
    [
      // Figura: forma de onda com dois pulsos estreitos em azul separados por grande intervalo temporal. Uma seta indica que os pulsos estão aproximadamente 16 ms apartados, enquanto outra seta marca a largura de um pulso como cerca de 100 ns. Uma quebra visual no eixo mostra que o desenho não está em escala.
      #align(center)[
        #image("fig/eth_link_pulses.jpg", width: 90%)
        #v(-0.6em)
        #text(size: 6pt)[UNH IOL, _Ethernet Evolution From 10 Meg to 10 Gig_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/ethernet/ethernet_evolution.pdf")[iol.unh.edu].]
      ]
    ],
  )
]

// ============================================================
// SLIDE 27 — FLP/autoneg
// ============================================================
#slide[
  == Fast Link Pulses (FLP) e autonegociação

  #set text(size: 17pt)
  - FLP reaproveita a compatibilidade dos pulsos 10BASE-T.
  - Um dispositivo antigo enxerga pulsos de link normais.
  - Um dispositivo novo interpreta rajadas como palavras de capacidade.
  - Campos anunciam 10/100 half/full, pause e _next page_.
  - Gigabit cobre usa autonegociação também para master/slave.

  #grid(
    columns: (1fr, 1fr),
    gutter: 0.7em,
    [
      // Figura: rajada FLP com uma sequência de 17 pulsos verticais pretos, rotulados como pulsos de clock NLP. Uma seta superior indica largura de rajada de 2 ms; outra marca a separação até a próxima rajada, da ordem de 16 ms. A figura mostra como vários pulsos compatíveis com NLP são agrupados em uma palavra de autonegociação.
      #image("fig/eth_flp_burst.svg", width: 100%)
    ],
    [
      // Figura: detalhe de um diagrama representando a estrutura de uma palavra de pulsos de rede. Uma linha preta horizontal na base serve de apoio para dezenove setas pretas altas que apontam para cima, representando pulsos de clock regularmente espaçados. Intercaladas entre essas setas pretas, em posições intermediárias específicas, há setas azuis mais curtas, também apontando para cima, que representam os pulsos de dados. Na parte superior da imagem, setas horizontais e textos dividem o gráfico em duas áreas. À esquerda, a indicação Selector Field abrange as primeiras posições e apresenta um único pulso de dado azul no primeiro espaço entre os clocks. À direita, a indicação Technology Ability Field abrange o restante do gráfico, com rótulos textuais alinhados acima das posições de dados. Lendo da esquerda para a direita, os rótulos indicam as capacidades: 10BT HDX, 10BT FDX, 100BT HDX, 100BT FDX, 100 T4, Pause, Asym. Pause, seguido por um espaço vazio, e depois Remote Fault, ACK e NP. Existem pulsos de dados azuis desenhados ativando as posições correspondentes aos rótulos 10BT HDX, 10BT FDX, 100BT HDX, 100BT FDX e Pause. As posições sob os rótulos 100 T4, Asym. Pause, Remote Fault, ACK e NP não possuem setas azuis.
      #image("fig/eth_flp_sample.svg", width: 100%)
    ],
  )
  #v(-0.5em)
  #align(center)[#text(size: 6pt)[UNH IOL, _Ethernet Evolution From 10 Meg to 10 Gig_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/ethernet/ethernet_evolution.pdf")[iol.unh.edu].]]
]

// ============================================================
// SLIDE 28 — CSMA/CD prática
// ============================================================
#slide[
  == CSMA/CD na Prática 3

  #set text(size: 21pt)
  - *Carrier sense:* `RxActivityDetector` pontua transições compatíveis com Manchester.
  - *Collision detect:* se RX fica ativo enquanto TX está ativo, considera colisão.
  - *Jam:* transmite atividade por 32 tempos de bit.
  - *Slot time:* 512 bit times, implementado por deslocamento de contador.
  - *Backoff:* LFSR escolhe número de slots dentro da janela.

  #v(0.4em)
  _Isso só é correto com hub half duplex; em full duplex, RX durante TX é esperado._
]

// ============================================================
// SLIDE 29 — 100BASE-TX
// ============================================================
#slide[
  == 100BASE-TX: Fast Ethernet sobre cobre

  #set text(size: 22pt)
  - 100 Mbit/s sobre Cat 5 ou melhor, até 100 m.
  - Mesmo par de dados do 10BASE-T: pinos 1--2 e 3--6.
  - Usa MII para separar MAC e PHY.
  - O fio não recebe Manchester: recebe MLT-3 após codificação e scrambling.

  #v(0.5em)
  #align(center)[`MAC -> MII -> PCS 4B/5B -> PMA/PMD -> MLT-3 no cabo`]
]

// ============================================================
// SLIDE 30 — 4B/5B
// ============================================================
#slide[
  == 4B/5B: transições e controle

  #set text(size: 7.1pt)
  #let shade = luma(235)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.6em,
    [
      #set text(size: 16pt)
      - Cada nibble de 4 bits vira um grupo de 5 bits.
      - Taxa no código: $100 " Mbit/s" times 5/4 = 125 " Mbaud"$.
      - Sobra espaço para símbolos de controle.
      - `/I/ = 11111` mantém idle com transições após NRZI (_NRZ invertido_).
      - `/J/K/` marca início; `/T/R/` marca fim.
    ],
    [
      #table(
        columns: (0.4fr, 0.4fr, 0.4fr, 1fr),
        inset: 2pt,
        stroke: 0.35pt,
        align: horizon,
        table.header([*PCS [4:0]*], [*Nome*], [*MII [3:0]*], [*Uso*]),
        [11110], [0], [0000], [Data 0],
        [01001], [1], [0001], [Data 1],
        [10100], [2], [0010], [Data 2],
        [10101], [3], [0011], [Data 3],
        [01010], [4], [0100], [Data 4],
        [01011], [5], [0101], [Data 5],
        [01110], [6], [0110], [Data 6],
        [01111], [7], [0111], [Data 7],
        [10010], [8], [1000], [Data 8],
        [10011], [9], [1001], [Data 9],
        [10110], [A], [1010], [Data A],
        [10111], [B], [1011], [Data B],
        [11010], [C], [1100], [Data C],
        [11011], [D], [1101], [Data D],
        [11100], [E], [1110], [Data E],
        [11101], [F], [1111], [Data F],
        [11111], [I], [indef.], [IDLE; preenchimento entre streams],
        table.cell(colspan: 4, fill: shade)[*Controle*],
        [11000], [J], [0101], [início de stream, parte 1 de 2; pareado com K],
        [10001], [K], [0101], [início de stream, parte 2 de 2; pareado com J],
        [01101], [T], [indef.], [fim de stream, parte 1 de 2; pareado com R],
        [00111], [R], [indef.], [fim de stream, parte 2 de 2; pareado com T],
        table.cell(colspan: 4, fill: shade)[*Erro e inválidos*],
        [00100], [H], [indef.], [erro transmitido; força falha de sinalização],
        [00000], [V], [indef.], [código inválido],
        [00001], [V], [indef.], [código inválido],
        [00010], [V], [indef.], [código inválido],
        [00011], [V], [indef.], [código inválido],
        [00101], [V], [indef.], [código inválido],
        [00110], [V], [indef.], [código inválido],
        [01000], [V], [indef.], [código inválido],
        [01100], [V], [indef.], [código inválido],
        [10000], [V], [indef.], [código inválido],
        [11001], [V], [indef.], [código inválido],
      )
      #align(center)[#text(size: 6pt)[UNH IOL, _Ethernet Evolution From 10 Meg to 10 Gig_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/ethernet/ethernet_evolution.pdf")[iol.unh.edu].]]
    ],
  )
]

// ============================================================
// SLIDE 31 — NRZI e MLT-3
// ============================================================
#slide[
  == NRZI e MLT-3

  #set text(size: 18pt)
  - NRZI: bit 1 causa transição; bit 0 mantém nível.
  - MLT-3 percorre quatro estados: $0 -> +1 -> 0 -> -1 -> 0$.
  - Transições diretas entre $+1$ e $-1$ não ocorrem.
  - Um trem de 1s a 125 Mbit/s vira componente principal em 31,25 MHz.
  - Isso cabe melhor no Cat 5 do que um tom de 125 MHz.

  // Figura: comparação de formas de onda para a mesma sequência binária. A linha superior lista bits 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0. Abaixo aparecem três traços: NRZ com níveis binários diretos, NRZI com transições em bits 1, e MLT-3 com níveis que percorrem 0, positivo, 0, negativo e 0. O diagrama mostra a redução de transições bruscas e de frequência dominante no MLT-3.
  #align(center)[
    #image("fig/eth_nrzi_mlt3_waveforms.png", width: 55%)
    #v(-1em)
    #text(size: 6pt)[UNH IOL, _100BASE-TX PMD_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/fe/100BASE-TX_PMD.pdf")[iol.unh.edu].]
  ]
]

// ============================================================
// SLIDE 32 — Scrambler
// ============================================================
#slide[
  == Scrambler: não é criptografia, é espectro

  #set text(size: 16pt)
  - O idle 4B/5B seria altamente periódico.
  - Periodicidade concentra energia e aumenta EMI.
  - Scrambler pseudoaleatoriza o fluxo antes do MLT-3.
  - 100BASE-TX usa LFSR de 11 bits.
  - O receptor precisa descramblar e sincronizar usando o idle.

  #align(center)[$ k[n] = k[n-9] xor k[n-11], quad c[n] = p[n] xor k[n] $]

  #grid(
    columns: (1fr, 1fr),
    gutter: 0.7em,
    [
      // Figura: registrador de deslocamento de 11 bits usado como LFSR. Blocos rotulados Bit 1, Bit 2, Bit 3, Bit 8, Bit 9, Bit 10 e Bit 11 aparecem em sequência, com bits intermediários omitidos. Setas vermelhas indicam deslocamento e realimentação por XOR; setas azuis indicam carga de semente.
      #image("fig/eth_100tx_lfsr.jpg", width: 100%)
    ],
    [
      // Figura: scrambler como cifrador de fluxo. Um Plaintext Stream azul entra em um XOR; um Key Stream vermelho gerado pelo LFSR também entra nesse XOR; a saída verde é o Ciphertext Stream. O desenho enfatiza que o fluxo é misturado por XOR para espalhar o espectro, não para prover segurança criptográfica.
      #image("fig/eth_100tx_scrambler.jpg", width: 100%)
    ],
  )
  #align(center)[#text(size: 6pt)[UNH IOL, _100BASE-TX PMD_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/fe/100BASE-TX_PMD.pdf")[iol.unh.edu].]]
]

// ============================================================
// SLIDE 33 — PMD 100BASE-TX
// ============================================================
#slide[
  == 100BASE-TX: blocos de uma PHY implementável

  #set text(size: 17pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.7em,
    [
      *TX*:
      - Conversão NRZI/NRZ (_Non-Return-to-Zero_) conforme fronteira PMA/PMD.
      - Scrambler.
      - Codificador MLT-3.
      - Driver diferencial com controle de amplitude e máscara.

      *RX*:
      - AFE, _slicer_, _signal detect_.
      - Equalização adaptativa e compensação de baseline wander.
      - Decodificador MLT-3.
      - Descrambler e CDR.
    ],
    [
      // Figura: diagrama funcional do TP-PMD 100BASE-TX entre PMA e meio físico. No caminho de transmissão, setas vermelhas descem por conversão NRZI para NRZ, scrambler de fluxo, codificador MLT-3 e transmissor. No caminho de recepção, setas azuis sobem por receptor, decodificador MLT-3, descrambler e conversão NRZ para NRZI. Um bloco separado de Signal Detect informa ao PMA se há sinal no meio.
      #align(center)[
        #image("fig/eth_100tx_pmd_blocks.jpg", width: 85%)
        #v(-0.6em)
        #text(size: 6pt)[UNH IOL, _100BASE-TX PMD_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/fe/100BASE-TX_PMD.pdf")[iol.unh.edu].]
      ]
    ],
  )
]

// ============================================================
// SLIDE 34 — Cabo e equalização
// ============================================================
#slide[
  == O cabo agora manda no projeto

  #set text(size: 14pt)
  - Atenuação cresce com frequência por efeito pelicular e perdas dielétricas.
  - O cabo arredonda bordas e espalha símbolos no tempo.
  - Magnetics removem DC (_corrente contínua_) e deslocam o baseline.
  - Equalização insuficiente deixa ISI (_Inter-Symbol Interference_); equalização excessiva cria overshoot e ringing.
  - Uma PHY comercial estima comprimento/perda e ajusta filtros.

  #v(-1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.7em,
    [
      // Figura: três gráficos temporais empilhados de um sinal MLT-3. O primeiro, Input, tem transições mais retas entre níveis -1, 0 e +1. O segundo, Output - 50m, aparece suavizado e atenuado. O terceiro, Output - 100m, fica ainda mais arredondado e com menor amplitude, mostrando a distorção crescente com o comprimento do cabo.
      #image("fig/eth_100tx_cable_distortion.jpg", width: 85%)
    ],
    [
      // Figura: três gráficos comparando equalização. O traço Ideal tem níveis bem definidos; o Under-equalized aparece amortecido e suavizado; o Over-equalized mostra picos, overshoot e ringing. A imagem ilustra que equalização insuficiente e excessiva degradam a decisão do receptor por mecanismos diferentes.
      #image("fig/eth_100tx_equalization.jpg", width: 85%)
    ],
  )
  #v(-2em)
  #align(center)[#text(size: 6pt)[UNH IOL, _100BASE-TX PMD_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/fe/100BASE-TX_PMD.pdf")[iol.unh.edu].]]
]

// ============================================================
// SLIDE 35 — Fronteira AFE/DSP
// ============================================================
#slide[
  == Quando o AFE deixa de bastar?

  #set text(size: 18pt)
  O AFE nunca desaparece; o que muda é *onde a decisão acontece*.

  #v(0.2em)
  #table(
    columns: (1.25fr, 2.6fr),
    inset: 4pt,
    stroke: 0.5pt,
    align: horizon,
    [*10BASE-T*], [comparador diferencial decide cedo; o digital recebe níveis binários e temporização por Manchester.],
    [*100BASE-TX*], [AFE mais cuidadoso; MLT-3 pode ser fatiado por limiares após equalização e compensação de baseline.],
    [*1000BASE-T*], [marco claro para ADC (_analog-to-digital converter_) / DAC (_digital-to-analog converter_) + DSP: PAM5, eco, NEXT (_diafonia local_) e full duplex nos quatro pares.],
    [*10GBASE-T+*], [DSP, FEC, canceladores adaptativos e conversores rápidos dominam a PHY.],
  )

  #v(0.2em)
  #text(size: 15.5pt)[Fibra NRZ (_Non-Return-to-Zero_) 1G/10G muitas vezes fica em AFE + CDR + slicer.\ Fibra PAM4 moderna exige DSP e FEC.]
]

// ============================================================
// SLIDE 36 — 100BASE-FX
// ============================================================
#slide[
  == 100BASE-FX: mesma taxa, outro meio

  #set text(size: 22pt)
  - 100 Mbit/s em fibra multimodo.
  - Reaproveita 4B/5B.
  - Não precisa de MLT-3: fibra tem banda maior.
  - Não precisa de scrambling para EMI: fibra não irradia como cabo metálico.
  - Implementação vira O/E (_optical-to-electrical_) e E/O (_electrical-to-optical_), limiar óptico, CDR e orçamento de potência.

  #v(0.4em)
  _Trocar o meio muda o PMD, mas não precisa mudar a MAC._
]

// ============================================================
// SLIDE 37 — 1000BASE-X
// ============================================================
#slide[
  == 1000BASE-X: Gigabit em fibra

  #set text(size: 15.5pt)
  - 1000BASE-SX (_Short Wavelength_): 850 nm, multimodo, curto alcance.
  - 1000BASE-LX (_Long Wavelength_): 1310 nm, multimodo ou monomodo.
  - Codificação *8B/10B*: 20% de overhead, controle e balanço DC.
  - SerDes serial em 1,25 Gbaud.
  - Running disparity ajuda detecção de erro e mantém espectro adequado ao acoplamento.

  #grid(
    columns: (1fr, 1fr),
    gutter: 0.7em,
    [
      // Figura: tabela de alcance do 1000BASE-SX. As linhas listam fibras multimodo de 62,5 micrometros e 50 micrometros com diferentes larguras de banda modal em 850 nm, resultando em alcances mínimos de 220 m, 275 m, 500 m e 550 m. Fibra monomodo aparece como não suportada.
      #image("fig/eth_1000sx_range.png", width: 100%)
    ],
    [
      // Figura: tabela de alcance do 1000BASE-LX. As linhas mostram fibras multimodo de 62,5 micrometros e 50 micrometros com alcance até 550 m em 1300 nm, e fibra monomodo de 10 micrometros com alcance até 5000 m. A comparação mostra o aumento de alcance em monomodo.
      #image("fig/eth_1000lx_range.png", width: 100%)
    ],
  )
  #v(-1em)
  #align(center)[#text(size: 6pt)[UNH IOL, _Ethernet Evolution From 10 Meg to 10 Gig_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/ethernet/ethernet_evolution.pdf")[iol.unh.edu].]]
]

// ============================================================
// SLIDE 38 — Fibra
// ============================================================
#slide[
  == Conceitos de fibra que entram na PHY

  #set text(size: 16pt)
  - *Multimodo:* vários caminhos; dispersão modal limita alcance e baud rate.
  - *Monomodo:* menor dispersão modal; alcances maiores.
  - *Dispersão cromática:* comprimentos de onda diferentes viajam com velocidades diferentes.
  - *Orçamento óptico:* potência do laser, perda de conectores/fibra e sensibilidade do receptor.
  - *CDR:* recupera clock do fluxo recebido, como nos meios elétricos.

  #v(-1em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.7em,
    [
      // Figura: comparação de três tipos de propagação óptica. A primeira fibra é multimodo de índice degrau, com vários raios refletindo em caminhos diferentes; a segunda é multimodo de índice gradual, com trajetórias mais suaves; a terceira é monomodo, com propagação concentrada em um caminho central. A figura mostra por que multimodo sofre dispersão modal e monomodo permite alcances maiores.
      #image("fig/eth_fiber_types.png", height: 60%)
    ],
    [
      // Figura: comparação de preenchimento modal por fontes LED e VCSEL. O LED lança luz em cone mais amplo e ocupa mais modos da fibra; o VCSEL lança feixe mais estreito próximo ao centro do núcleo. O desenho destaca núcleo e casca e mostra que a forma de lançamento altera a distribuição modal e o desempenho em fibra multimodo.
      #image("fig/eth_fiber_launch.png", height: 60%)
    ],
  )
  #v(-1.5em)
  #align(center)[#text(size: 6pt)[UNH IOL, _Ethernet Evolution From 10 Meg to 10 Gig_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/ethernet/ethernet_evolution.pdf")[iol.unh.edu].]]
]

// ============================================================
// SLIDE 39 — 1000BASE-T
// ============================================================
#slide[
  == 1000BASE-T: Gigabit em quatro pares

  #grid(
    columns: (1fr, 1fr),
    gutter: 0.7em,
    [
      #set text(size: 22pt)
      - Cat 5 ou melhor, 100 m, todos os quatro pares.
      - Taxa simbólica: 125 MBd por par.
      - Sinalização PAM5 em quatro dimensões.
      - Transmite e recebe simultaneamente em cada par.
      - Requer cancelamento de eco, NEXT e equalização adaptativa.
      - Usa codificação Trellis e decisão por Viterbi.
    ],
    [
      // Figura: diagrama de interferências em quatro pares trançados usados por 1000BASE-T. À esquerda está o lado local e à direita o lado remoto; cada par tem transmissor e receptor. Setas coloridas identificam eco do próprio transmissor, atenuação do sinal remoto, NEXT vindo de transmissores locais em outros pares e ELFEXT vindo de transmissores remotos. A figura mostra por que canceladores e equalização adaptativa são essenciais no Gigabit em cobre.
      #align(center)[
        #image("fig/eth_1000t_noise.png", width: 90%)
        #v(-0.6em)
        #text(size: 8pt)[UNH IOL, _Ethernet Evolution From 10 Meg to 10 Gig_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/ethernet/ethernet_evolution.pdf")[iol.unh.edu].]
      ]
    ],
  )
]

// ============================================================
// SLIDE 40 — 1000BASE-T conta
// ============================================================
#slide[
  == Conta de engenharia do 1000BASE-T

  #set text(size: 22pt)
  Partindo de 125 MBd:

  #align(center)[
    $ 125 " Msym/s" times 4 " pares" times 2 " bits/símbolo" = 1000 " Mbit/s" $
  ]

  - Os cinco níveis dão folga de símbolos além dos 2 bits por par.
  - A dimensão conjunta dos quatro pares permite codificação mais robusta.
  - O preço é DSP pesado e treinamento de canal.
]

// ============================================================
// SLIDE 41 — Full duplex no mesmo par
// ============================================================
#slide[
  == Full-duplex no mesmo par: eco controlado

  #set text(size: 21pt)
  Cada receptor observa:

  #align(center)[$ r_i (t) = h_i (t) * x_"remoto" (t) + e_i (t) * x_"local" (t) + sum_j c_(i j)(t) * x_j (t) + n_i (t) $]

  - Eco: meu próprio transmissor volta ao meu receptor.
  - NEXT: meus outros transmissores acoplam no par recebido.
  - FEXT (_Far-End Crosstalk_) / ELFEXT (_Equal-Level FEXT_): transmissões remotas acoplam entre pares.
  - Implementação: filtros FIR (_Finite Impulse Response_) adaptativos, slicer, DFE (_Decision Feedback Equalizer_) / FFE (_Feed-Forward Equalizer_) e laços de treinamento.
]

// ============================================================
// SLIDE 42 — Master/slave
// ============================================================
#slide[
  == Master/slave e treinamento

  #set text(size: 22pt)
  - 1000BASE-T precisa de referência comum para filtros adaptativos e temporização.
  - Autonegociação decide master e slave.
  - Master transmite com clock local.
  - Slave recupera esse clock e usa a referência para transmitir.
  - Antes de dados, a PHY estima canal, eco, diafonia e ganho.

  #v(0.4em)
  _A PHY passa a parecer um modem multicanal adaptativo._
]

// ============================================================
// SLIDE 43 — 10GBASE-T
// ============================================================
#slide[
  == 10GBASE-T: o limite do cobre fica caro

  #set text(size: 16pt)
  - 10 Gbit/s em quatro pares até 100 m em Cat 6A.
  - Taxa simbólica de 800 MBd por par.
  - PAM16 com codificação DSQ128 (_double-square 128_) e LDPC (_Low-Density Parity-Check_).
  - Cancelamento de eco e diafonia muito mais exigente.
  - ADC/DAC de alta velocidade, filtros adaptativos longos e FEC dominam área e potência.
  - Alien crosstalk de cabos vizinhos vira parte do orçamento.

  // Figura: diagrama em blocos de uma PHY 10GBASE-T. À esquerda, uma MAC 10G conectada por XGMII entra no PCS. O fluxo passa por FEC LDPC, mapper PAM16/DSQ128 e DSP. O DSP se conecta a quatro caminhos iguais, um por par trançado, cada um com DAC no transmissor, ADC no receptor e AFE bidirecional. Entre os quatro caminhos há canceladores de eco, NEXT e FEXT, além de equalizador adaptativo antes da decisão.
  #align(center)[
    #text(size: 10pt)[
      #fletcher.diagram(
        spacing: (0.75em, 1.25em),
        node-stroke: 0.8pt,
        edge-stroke: 0.8pt,
        node((0,0), [10G MAC]), edge("-|>"),
        node((1,0), [XGMII]), edge("-|>"),
        node((2,0), [PCS]), edge("-|>"),
        node((3,0), [LDPC/FEC]), edge("-|>"),
        node((4,0), [PAM16\ mapper]), edge("-|>"),
        node((5,0), [DSP: eco\ NEXT/FEXT\ equalizador], shape: fletcher.shapes.rect),
        node((6,-1.2), [AFE par 1\ DAC/ADC], shape: fletcher.shapes.pill),
        node((6,-0.4), [AFE par 2\ DAC/ADC], shape: fletcher.shapes.pill),
        node((6,0.4), [AFE par 3\ DAC/ADC], shape: fletcher.shapes.pill),
        node((6,1.2), [AFE par 4\ DAC/ADC], shape: fletcher.shapes.pill),
        edge((5,0), (6,-1.2), "-|>"),
        edge((5,0), (6,-0.4), "-|>"),
        edge((5,0), (6,0.4), "-|>"),
        edge((5,0), (6,1.2), "-|>"),
      )
    ]
  ]
]

// ============================================================
// SLIDE 44 — 10G óptico
// ============================================================
#slide[
  == 10 Gigabit Ethernet em fibra

  #grid(
    columns: (1.2fr, 0.8fr),
    gutter: 0.7em,
    [
      #set text(size: 16pt)
      - 10GbE abandona half duplex: operação full duplex apenas.
      - 10GBASE-R usa 64B/66B e serialização ~10,3125 Gbaud.
      - SR (_Short Reach_): 850 nm multimodo, curto alcance.
      - LR (_Long Reach_): 1310 nm monomodo, ~10 km.
      - ER (_Extended Reach_): 1550 nm monomodo, ~40 km.
      - LX4 usava WDM em quatro comprimentos de onda para reutilizar fibras instaladas.
    ],
    [
      // Figura: arquitetura de PHYs 10 Gigabit Ethernet sob a mesma MAC e XGMII. Abaixo da MAC aparecem três famílias: 10GBASE-LX4 com PCS 8B/10B e quatro lanes de 3,125 Gb/s; 10GBASE-SR/LR/ER com PCS 64B/66B e serialização de 10,3125 Gb/s; e 10GBASE-SW/LW/EW com WIS para WAN e taxa compatível com SONET/SDH. A figura mostra que as opções ópticas diferem abaixo da interface comum.
      #align(center)[
        #image("fig/eth_10g_phy_arch.jpg", width: 90%)
        #v(-0.6em)
        #text(size: 6pt)[UNH IOL, _Ethernet Evolution From 10 Meg to 10 Gig_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/ethernet/ethernet_evolution.pdf")[iol.unh.edu].]
      ]
    ],
  )
]

// ============================================================
// SLIDE 45 — 64B/66B
// ============================================================
#slide[
  == 64B/66B: overhead pequeno, CDR ainda possível

  #set text(size: 21pt)
  - 8B/10B tem 25% de baud overhead sobre os dados úteis.
  - 64B/66B adiciona 2 bits a cada 64 bits úteis: overhead de cerca de 3,125%.
  - Cabeçalho de 2 bits distingue dados e controle.
  - Scrambler evita sequências longas e espalha espectro.
  - O receptor precisa de _block lock_ antes de entregar bytes à MAC.

  #v(0.4em)
  #align(center)[`01` = bloco de dados; `10` = bloco de controle, em forma simplificada.]
]

// ============================================================
// SLIDE 46 — Interfaces internas
// ============================================================
#slide[
  == Interfaces internas: MII até SerDes

  #set text(size: 12pt)
  #table(
    columns: (1fr, 0.7fr, 2fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Interface*], [*Uso típico*], [*Motivo*]),
    [MII], [100 Mb/s], [barramento paralelo simples entre MAC e PHY],
    [GMII/RGMII (_Reduced GMII_)], [1 Gb/s], [8 bits por ciclo ou versão reduzida por DDR (_Double Data Rate_)],
    [XGMII], [10 Gb/s], [32 bits + controle; muitos pinos],
    [XAUI], [10 Gb/s], [4 lanes SerDes de 3,125 Gb/s; menos pinos],
    [Serial SerDes], [25G+], [PHY/MAC integradas por lanes diferenciais de alta velocidade],
  )

  // Figura: cadeia de blocos 10 Gigabit com destaque para a interface XAUI. Da esquerda para a direita aparecem MAC com reconciliação, SerDes 8B/10B de quatro lanes a 3,125 Gb/s, blocos de conversão para 64B/66B/WIS, SerDes 10G e óptica. Um oval vermelho destaca que XAUI usa 4 lanes diferenciais em transmissão e recepção, totalizando 16 conexões ponto a ponto, em contraste com interfaces paralelas XGMII de muitos pinos.
  #align(center)[
    #image("fig/eth_xgmii_xaui.jpg", width: 48%)
    #v(-1em)
    #text(size: 6pt)[UNH IOL, _Ethernet Evolution From 10 Meg to 10 Gig_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/ethernet/ethernet_evolution.pdf")[iol.unh.edu].]
  ]
]

// ============================================================
// SLIDE 47 — Pluggables
// ============================================================
#slide[
  == Módulos ópticos: onde termina o chip?

  #set text(size: 17pt)
  - GBIC/SFP/QSFP separaram equipamento e PMD substituível.
  - O host fornece SerDes, alimentação, controle e gerência.
  - O módulo contém laser, fotodiodo, TIA (_Transimpedance Amplifier_), driver, CDR e às vezes DSP/FEC.
  - A fronteira de implementação muda com a velocidade e com o custo térmico.

  // Figura: diagrama de módulo óptico XENPAK. À esquerda fica a eletrônica do host com MAC e SerDes 8B/10B de quatro lanes. À direita, dentro de uma área colorida pontilhada representando o módulo, aparecem MDIO, 64B/66B e WIS, SerDes 10G e dois blocos ópticos de transmissão e recepção. A figura evidencia a fronteira entre placa host, interface XAUI e PMA/PMD dentro do módulo removível.
  #align(center)[
    #image("fig/eth_xenpak_block.jpg", width: 62%)
    #v(-0.6em)
    #text(size: 8pt)[UNH IOL, _Ethernet Evolution From 10 Meg to 10 Gig_, obtido de #link("https://www.iol.unh.edu/sites/default/files/knowledgebase/ethernet/ethernet_evolution.pdf")[iol.unh.edu].]
  ]
]

// ============================================================
// SLIDE 48 — 40G/100G primeiras gerações
// ============================================================
#slide[
  == 40G e 100G: paralelismo primeiro

  #set text(size: 22pt)
  - Primeiras gerações escalaram agregando lanes.
  - 40G: 4 lanes de 10G ou comprimentos de onda paralelos.
  - 100G: 10 lanes de 10G, depois 4 lanes de 25G.
  - PCS distribui blocos por lanes e usa marcadores para realinhar no receptor.
  - Óptica pode ser paralela por várias fibras ou WDM em uma fibra.

  // Figura: diagrama de transmissão 100G inicial por lanes paralelas. À esquerda, uma MAC 100G entrega dados ao PCS 100G, que distribui o fluxo em quatro lanes. Cada lane passa por SerDes, driver óptico e uma fibra ou comprimento de onda. À direita, o receptor converte cada lane, aplica deskew para realinhar atrasos diferentes e recombina o fluxo antes de entregar novamente ao PCS/MAC.
  #align(center)[
    #text(size: 10pt)[
      #fletcher.diagram(
        spacing: (0.75em, 1.0em),
        node-stroke: 0.8pt,
        edge-stroke: 0.8pt,
        node((-1,0), [100G MAC]), edge("-|>"),
        node((0,0), [PCS\ distribui]),
        node((2,-1.2), [lane 1\ SerDes -> óptica], shape: fletcher.shapes.pill),
        node((2,-0.4), [lane 2\ SerDes -> óptica], shape: fletcher.shapes.pill),
        node((2,0.4), [lane 3\ SerDes -> óptica], shape: fletcher.shapes.pill),
        node((2,1.2), [lane 4\ SerDes -> óptica], shape: fletcher.shapes.pill),
        edge((0,0), (2,-1.2), "-|>"), edge((0,0), (2,-0.4), "-|>"), edge((0,0), (2,0.4), "-|>"), edge((0,0), (2,1.2), "-|>"),
        node((3,-1.2), [fibra/λ 1]), node((3,-0.4), [fibra/λ 2]), node((3,0.4), [fibra/λ 3]), node((3,1.2), [fibra/λ 4]),
        edge((2,-1.2), (3,-1.2), "-|>"), edge((2,-0.4), (3,-0.4), "-|>"), edge((2,0.4), (3,0.4), "-|>"), edge((2,1.2), (3,1.2), "-|>"),
        node((4,0), [deskew\ realinha lanes], shape: fletcher.shapes.rect),
        edge((3,-1.2), (4,0), "-|>"), edge((3,-0.4), (4,0), "-|>"), edge((3,0.4), (4,0), "-|>"), edge((3,1.2), (4,0), "-|>"),
        edge((4,0), (5,0), "-|>"), node((5,0), [PCS\ recompõe]), edge("-|>"), node((6,0), [100G MAC]),
      )
    ]
  ]
]

// ============================================================
// SLIDE 49 — PAM4
// ============================================================
#slide[
  == PAM4: quando NRZ deixa de escalar bem

  #set text(size: 16pt)
  - NRZ transmite 1 bit por símbolo: dois níveis.
  - PAM4 transmite 2 bits por símbolo: quatro níveis.
  - Para a mesma taxa de bits por lane, o baud rate cai pela metade.
  - A penalidade é menor distância vertical entre níveis: exige SNR, linearidade e FEC.
  - Hoje aparece em 50G, 100G, 200G, 400G e 800G por lane/lane groups.

  // Figura: comparação conceitual de diagramas de olho. À esquerda, NRZ tem dois níveis e um único olho vertical grande, com boa margem de ruído. À direita, PAM4 tem quatro níveis e três olhos menores empilhados, reduzindo a margem vertical. Uma anotação indica que, para a mesma taxa de bits, PAM4 carrega dois bits por símbolo e pode operar com metade do baud rate, pagando com menor separação entre níveis.
  #align(center)[
    #image("fig/pam4_eye_compare.svg", width: 72%)
  ]
]

// ============================================================
// SLIDE 50 — 100G moderno
// ============================================================
#slide[
  == 100G moderno: exemplo de PHY PAM4

  #set text(size: 21pt)
  - 100GBASE-DR/FR/LR usam uma lane óptica PAM4 de ~53 GBd.
  - DR: curto alcance em monomodo.
  - FR: ~2 km.
  - LR: ~10 km.
  - O chip precisa de DSP: equalização, CDR, controle de laser/modulador, TIA, ADC ou comparadores multinível.
  - FEC Reed-Solomon passa a ser parte essencial do enlace.

  #v(0.4em)
  _Em 10BASE-T, FEC não era necessário; em 100G PAM4, sem FEC o orçamento fecha mal._
]

// ============================================================
// SLIDE 51 — FEC moderna
// ============================================================
#slide[
  == FEC em Ethernet moderna

  - CRC detecta erro; FEC corrige erro antes da MAC.
  - Reed-Solomon é comum em 25G/50G/100G+.
  - A PHY opera com BER (_Bit Error Rate_) bruta pior e entrega BER pós-FEC aceitável.
  - Custo: latência, área, potência e complexidade de verificação.
  - Projeto de PHY moderna é co-projeto de modulação, canal, equalização e FEC.
]

// ============================================================
// SLIDE 52 — Cobre moderno fora RJ45
// ============================================================
#slide[
  == Cobre moderno: backplane e DAC

  #set text(size: 21pt)
  - Nem todo cobre Ethernet moderno é par trançado de 100 m.
  - Backplane: trilhas de placa e conectores dentro de chassi.
  - DAC: cabo twinax curto entre equipamentos.
  - 25G/50G/100G por lane usam SerDes com CTLE (_Continuous-Time Linear Equalizer_), FFE, DFE e CDR.
  - PAM4 reduz baud, mas exige calibração e linearidade.

  #v(0.4em)
  _O problema parece mais com projeto de SerDes de alta velocidade do que com 10BASE-T._
]

// ============================================================
// SLIDE 53 — Caminho de implementação
// ============================================================
#slide[
  == Se fôssemos implementar em silício: caminho essencial

  #set text(size: 19.5pt)
  #table(
    columns: (1.15fr, 2.8fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Tecnologia*], [*Blocos essenciais além da MAC*]),
    [10BASE-T], [Manchester, comparador diferencial, link pulses, CSMA/CD],
    [100BASE-TX], [4B/5B, scrambler, MLT-3, equalização, baseline wander],
    [1000BASE-T], [4D-PAM5, ADC/DAC, canceladores, Trellis/Viterbi, treinamento],
    [10GBASE-T], [PAM16, LDPC, DSP intenso, alien crosstalk, AFE rápido],
    [10G óptico], [64B/66B, SerDes, CDR, laser/fotodiodo, orçamento óptico],
    [100G+], [lanes, PAM4, FEC Reed-Solomon (RS), DSP óptico/elétrico, deskew],
  )
]

// ============================================================
// SLIDE 54 — Teoria necessária
// ============================================================
#slide[
  == Conceitos teóricos que viram transistores

  #set text(size: 24pt)
  - Linhas de transmissão: $Z_0$, reflexões, atenuação, dispersão.
  - Modulação PAM e diagramas de olho.
  - Clock recovery, PLL (_Phase-Locked Loop_) / CDR e jitter.
  - Códigos de linha, balanceamento DC e densidade de transições.
  - Scrambling e espectro.
  - Equalização adaptativa e estimação de canal.
  - FEC, CRC e aritmética em GF(2).
  - Projeto analógico: drivers, comparadores, ADC/DAC, TIA e CML (_Current-Mode Logic_).
]

// ============================================================
// SLIDE 55 — O que simplificamos
// ============================================================
#slide[
  == O que a Prática 3 simplifica de propósito

  #set text(size: 22pt)
  - Não há autonegociação FLP.
  - Não há 100BASE-TX nem 1000BASE-T.
  - Não há validação completa de FCS no RX.
  - Não há MAC genérica com filas arbitrárias.
  - Detecção de atividade/fim é heurística.
  - AFE é para cabo curto de bancada, não para 100 m certificados.

  #v(0.5em)
  _A simplificação revela os mecanismos fundamentais sem esconder tudo._
]

// ============================================================
// SLIDE 56 — Comparação de códigos
// ============================================================
#slide[
  == Comparação de formas de onda

  #set text(size: 18pt)
  #table(
    columns: (1.1fr, 1.3fr, 2.4fr),
    inset: 5pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*PHY*], [*Forma no meio*], [*Motivo da escolha*]),
    [10BASE-T], [Manchester], [transição por bit; CDR simples; banda maior],
    [100BASE-TX], [MLT-3], [reduz frequência efetiva após 4B/5B/NRZI],
    [100BASE-FX], [NRZI óptico], [fibra aceita banda maior; sem EMI metálica],
    [1000BASE-X], [NRZ serial 8B/10B], [SerDes simples com DC balance],
    [1000BASE-T], [4D-PAM5], [4 pares, 2 bits/símbolo/par e DSP],
    [10GBASE-T], [PAM16], [mais bits por símbolo com FEC/DSP],
    [100G+], [NRZ ou PAM4 por lane], [paralelismo, alcance, custo e potência],
  )
]

// ============================================================
// SLIDE 57 — Prática como microcosmo
// ============================================================
#slide[
  == A Prática 3 como microcosmo da Ethernet

  #set text(size: 22pt)
  Ela contém, em escala didática:
  - forma de onda no meio físico;
  - recuperação de temporização;
  - delimitação por preâmbulo e SFD;
  - desserialização LSB-first;
  - endereçamento MAC e ARP;
  - CRC-32/FCS no TX;
  - carrier sense, collision detect, jam e backoff;
  - cruzamento de domínios de clock e observabilidade por UART.
]

// ============================================================
// SLIDE 58 — Síntese
// ============================================================
#slide[
  == Síntese

  #set text(size: 22pt)
  - Ethernet começou como meio compartilhado com CSMA/CD.
  - Hubs preservaram colisões; switches as eliminaram.
  - Quadro e endereçamento ficaram estáveis enquanto as PHYs mudaram.
  - 10BASE-T é implementável com lógica simples e AFE discreto.
  - 100M, 1G, 10G e 100G exigem progressivamente codificação, DSP, SerDes, FEC e projeto analógico avançado.
]

// ============================================================
// SLIDE 59 — Como ler a prática
// ============================================================
#slide[
  == Como ler a prática

  #set text(size: 22pt)
  A prática não precisa pedir que vocês implementem todos estes blocos.

  O objetivo é reconhecer, no sistema pronto ou parcialmente pronto:

  - Qual parte transforma tensão diferencial em bits?
  - Onde o receptor se sincroniza com o preâmbulo?
  - Onde o SFD separa sincronização de conteúdo?
  - Onde aparece a ordem LSB-first dos bits?
  - Onde o quadro ganha tamanho mínimo, IPG e FCS?
  - Onde carrier sense, colisão, jam e backoff entram se o cenário usar hub?
]
