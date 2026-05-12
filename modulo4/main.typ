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

    Módulo 4 -- Antenas, propagação, radioamadorismo \
    e comunicação via satélite

    #text(size: 18pt)[Da teoria de antenas ao enlace com satélites de radioamador]

    Prof. Paulo Matias
  ]
]

// ============================================================
// SLIDE 2 — Objetivos
// ============================================================
#slide[
  == Objetivos deste módulo

  #set text(size: 17pt)

  Ao fim desta aula, o aluno deve saber responder:

  - O que é radioamadorismo, como se licenciar no Brasil, e o que é possível fazer sob supervisão ou em ISM/radiação restrita.
  - Como antenas radiam: da equação de Maxwell a $R_r + j X$; por que o modelo de _lumped elements_ é só um atalho para um fenômeno de propagação.
  - Como projetar uma antena Yagi-Uda; como funcionam _hairpin_, _gamma match_ e baluns.
  - Como o PyNEC (NEC2++) e o OpenEMS simulam antenas: Método dos Momentos (MoM) e FDTD.
  - Como usar o NanoVNA para aferir antenas e conectar medidas com simulação.
  - Como calcular _link budget_ para um enlace com satélite (foco na ISS em 145,825 MHz).
  - APRS sobre AX.25; introdução a Reed-Solomon; IL2P como substituto moderno.
]

// ============================================================
// SLIDE 3 — Radioamadorismo: o que é e motivação
// ============================================================
#slide[
  == Radioamadorismo

  #set text(size: 20pt)
  #grid(
    columns: (1fr, 0.3fr),
    gutter: 1em,
    [
      - Serviço de radiocomunicações voltado a *aprendizado, experimentação técnica e comunicação entre radioamadores*.
      - Sem fins comerciais: autoformação, intercomunicação, experimentação e apoio em emergências.
      - No Brasil: regulado pela Anatel; LABRE = sociedade-membro brasileira da IARU (região 2).
      - Motivações práticas: HF DX, VHF/UHF local, comunicação com a ISS e satélites, construir suas próprias antenas, estudar propagação.
      - Motivações para engenharia: laboratório pessoal para RF, com cobertura legal e espectro protegido para experimentar.
    ],
    [
      // Figura: símbolo internacional do radioamadorismo, com um losango amarelo contornado em preto contendo uma antena vertical preta, uma bobina e setas indicando transmissão e recepção de sinais de rádio.
      #align(center)[#image("fig/International_amateur_radio_symbol.svg", height: 68%)]
    ],
  )
]

// ============================================================
// SLIDE 4 — Como se tornar radioamador no Brasil
// ============================================================
#slide[
  == Como se tornar radioamador no Brasil

  #set text(size: 18pt)

  Passo a passo prático:

  + *Organize documentos*: RG com foto, e-mail, computador com câmera e microfone, ambiente silencioso.
  + *Cadastre-se* nos sistemas Anatel: SEI (processos) e SEC (prova eletrônica).
  + *Inscreva-se pelo SEC* na agenda de provas. Menores: pelo responsável legal. Pessoas com deficiência visual: prova oral com o avaliador.
  + *Realize a prova online* via Teams: câmera sempre ligada, sem fone, sem celular, sem outras pessoas.
  + *Receba o COER* (_Certificado de Operador de Estação de Radioamador_) e solicite a autorização/licença da estação.

  #text(size: 14pt)[Mais detalhes: #link("https://informacoes.anatel.gov.br/legislacao/resolucoes/2025/2022-resolucao-777")[Res. Anatel 777/2025], #link("https://sei.anatel.gov.br/sei/modulos/pesquisa/md_pesq_documento_consulta_externa.php?8-74Kn1tDR89f1Q7RjX8EYU46IzCFD26Q9Xx5QNDbqYV9Lv1DxCZqwO2Ketu0NN3Wu9_uAxScVoZGJsVedsk1AEZJkzUQukhdBwM3OBlHqo5O0FToLu-a2cP80mpmYhC")[Ato 3448/2026] e #link("https://sistemas.anatel.gov.br/anexar-api/publico/anexos/download/6067372ab14ee1c9702eb7ff93f11323")[Cartilha Anatel].]
]

// ============================================================
// SLIDE 5 — Classes A/B/C
// ============================================================
#slide[
  == Classes: privilégios e progressão

  #set text(size: 14pt)
  #table(
    columns: (0.25fr, 1.10fr, 0.52fr, 1.15fr, 0.9fr),
    inset: 4pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Classe*], [*Prova*], [*Potência máx.*], [*Faixas*], [*Pré-requisitos*]),
    [C], [15 q/matéria, 8 acertos, 20 min; eletrônica *básica*], [100 W], [VHF+; 15/12/10 m; HF baixa parcial], [idade $>=$ 10 anos],
    [B], [20 q/matéria, 11 acertos, 30 min; eletrônica *aplicada*], [1000 W], [C + 40 m (7,047--7,300) e 15 m (21,150--21,300)], [se idade $<$18, 2 anos em C],
    [A], [30 q/matéria, 16 acertos, 40 min; eletrônica *técnica*], [1500 W], [todas HF; 60 m (25 W PIRE)], [1 ano em B],
  )

  #v(0.4em)
  #set text(size: 16pt)
  - Matérias: *Técnica e Ética*, *Legislação*, *Eletrônica e Eletricidade*.
  - *VHF+* aqui significa VHF, UHF, SHF e EHF.
  - Potência é medida na *saída do transmissor*.
  - Radioamadores podem operar equipamento de fabricação própria no SRA, respeitando classe, faixas, potência e limites técnicos.
  - PIRE (e.i.r.p.) considera o ganho da antena. Sub-faixas específicas têm limites próprios em PIRE (ex.: 60 m = 25 W PIRE só para Classe A).
]

// ============================================================
// SLIDE 6 — Supervisão, ISM, radiação restrita
// ============================================================
#slide[
  == Operar sem COER próprio

  #set text(size: 16pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      *Sob supervisão de radioamador licenciado*
      - Terceiros não-radioamadores podem operar a estação sob *supervisão* do titular do COER.
      - A operação fica regida pela *classe do titular* (potência, faixas, identificação).
      - O titular continua responsável pela ética, pelos limites técnicos e pela identificação.
      - Base: #link("https://sei.anatel.gov.br/sei/modulos/pesquisa/md_pesq_documento_consulta_externa.php?8-74Kn1tDR89f1Q7RjX8EYU46IzCFD26Q9Xx5QNDbqYV9Lv1DxCZqwO2Ketu0NN3Wu9_uAxScVoZGJsVedsk1AEZJkzUQukhdBwM3OBlHqo5O0FToLu-a2cP80mpmYhC")[Ato Anatel 3448/2026].
    ],
    [
      *Sem supervisão: ISM e radiação restrita*
      - Equipamentos homologados de *radiação restrita*: Wi-Fi 2,4/5 GHz, BLE, LoRa 915 MHz, módulos 433 MHz.
      - Sem proteção contra interferência; potência/antena/uso dependem da aplicação.
      - Rádio caseiro exigiria ensaios laboratoriais caros; use módulos homologados.
      - Normas: #link("https://informacoes.anatel.gov.br/legislacao/resolucoes/2017/936-resolucao-680")[Res. 680/2017] e #link("https://informacoes.anatel.gov.br/legislacao/atos-de-certificacao-de-produtos/2017/1139-ato-14448")[Ato 14448/2017].
    ],
  )
]

// ============================================================
// SLIDE 7 — Indicativos
// ============================================================
#slide[
  == Indicativos e regiões

  #set text(size: 15pt)
  #grid(
    columns: (2.3fr, 1fr),
    gutter: 1em,
    [
      - Série ITU para o Brasil: *PP*A--*PY*Z e *ZV*A--*ZZ*Z.
      - Prefixos dependem de UF e classe; consulte a tabela oficial.
      - Formato efetivo: *prefixo + algarismo + sufixo*; A/B usam 2--3 letras, C usa 3 letras (ex.: PY2XYZ, PU5ABC).
      - Indicativos especiais (ex.: ZV201ID) são vinculados a eventos.
      - *Identificação*: indicativo completo no início, durante e fim do comunicado.
      - Sufixos proibidos: DDD, SNM, SOS, SVH, TTT, XXX, PAN, RRR, série QAA--QZZ.
    ],
    [
      #table(
        columns: (0.1fr, 1fr),
        inset: 5pt,
        stroke: 0.3pt,
        align: horizon,
        table.header([*Nº*], [*UFs*]),
        [0], [Ilhas oceânicas, Antártica],
        [1], [RJ, ES],
        [2], [SP, GO, TO, DF],
        [3], [RS],
        [4], [MG],
        [5], [PR, SC],
        [6], [BA, SE],
        [7], [AL, PE, PB, RN, CE],
        [8], [PI, MA, AM, PA, AP, RR, RO, AC],
        [9], [MT, MS],
      )
    ],
  )
]

// ============================================================
// SLIDE 8 — Plano de bandas brasileiro (visão geral)
// ============================================================
#slide[
  == Plano de bandas brasileiro (visão geral)

  #set text(size: 15pt)
  #table(
    columns: (0.6fr, 0.8fr, 0.8fr, 1.2fr),
    inset: 4pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Faixa*], [*Freq.*], [*Classes*], [*Observações*]),
    [160 m], [1,8--2,0 MHz], [todas até 1,85; A além], [propagação noturna, grandes antenas],
    [80 m], [3,5--4,0 MHz], [todas até 3,800; A além], [contatos regionais noturnos],
    [60 m], [5,3515--5,3665 MHz], [*só A*, 25 W PIRE], [NVIS/regional],
    [40 m], [7,0--7,3 MHz], [todas até 7,047; A/B além], [NVIS diurno; DX noturno],
    [20/17/30 m], [várias], [*só Classe A*], [DX; 30 m CW/dados],
    [15/12/10/6 m], [várias], [todas; 15 m parcial], [ciclo solar; Es/TEP],
    [*2 m*], [144--148 MHz], [todas], [repetidoras, APRS, *SAT 145,8--146*],
    [*70 cm*], [430--440 MHz], [todas], [repetidoras, *SAT 435--438*],
    [Outras V/U/SHF], [220; 902--907,5; 915--928; 1240 MHz+], [todas], [1,3 m, 33 cm, 23 cm e micro-ondas],
  )

  #v(0.3em)
  #text(size: 13pt)[Cada banda possui restrições específicas sobre modos de operação. Para mais detalhes, consulte o #link("https://informacoes.anatel.gov.br/legislacao/atos-de-requisitos-tecnicos-de-gestao-do-espectro/2024/1919-ato-926")[Ato Anatel 926/2024] ou o #link("https://qtc.ecra.club/2024/02/baixe-ja-o-novo-plano-de-bandas-ATUALIZADO-2024.html")[Infográfico do Plano de Bandas editado pela ECRA].]
]

// ============================================================
// SLIDE 9 — 2 m em detalhe
// ============================================================
#slide[
  == Banda de 2 m em detalhe

  #set text(size: 14pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.7em,
    [
      #table(
        columns: (1.2fr, 1.5fr),
        inset: 5pt,
        stroke: 0.35pt,
        align: horizon,
        table.header([*MHz*], [*Uso*]),
        [144,000--144,400], [CW/SSB/digitais por subfaixa; SAT/EME/DX/chamadas],
        [144,600--144,900], [*Entrada de repetidoras*],
        [145,000--145,200], [ACDS/IVG],
        [145,200--145,500], [*Saída de repetidoras*],
        [145,565--145,575], [APRS terrestre BR],
        [*145,800--146,000*], [*SAT exclusivo*: ISS, OSCAR],
        [146,000--146,390], [*Entrada de repetidoras*],
        [146,390--146,600], [chamada FM 146,520],
        [146,600--147,400], [*Saída de repetidoras*],
        [147,590--148,000], [*Entrada de repetidoras*],
      )
    ],
    [
      #set text(size: 16pt)
      *Pontos nodais:*
      - Frequência nacional de chamada FM: *146,520 MHz*.
      - *145,825 MHz*: #link("https://www.ariss.org/current-status-of-iss-stations.html")[APRS ISS]; alias `ARISS`/`APRSAT`, indicativo conforme status ARISS.
      - Offset típico em 2 m: 600 kHz; acima de 146,990 MHz há inversão do sentido entrada/saída no plano.
      - #text(size: 12pt)[Resumo didático: modos e aplicações variam por subfaixa; consulte o #link("https://informacoes.anatel.gov.br/legislacao/atos-de-requisitos-tecnicos-de-gestao-do-espectro/2024/1919-ato-926")[Ato Anatel 926/2024] para operação real.]

      *Oportunidades para este módulo:*
      - Construir Yagi de 3 elementos para 145,8 MHz.
      - Fazer digipeating via ISS, ver o pacote voltar em outra região do continente.
      - APRSdroid (Android) + rádio portátil + Yagi apontada.
    ],
  )
]

// ============================================================
// SLIDE 10 — 70 cm em detalhe
// ============================================================
#slide[
  == Banda de 70 cm em detalhe

  #set text(size: 15pt)
  #grid(
    columns: (1fr, 1.2fr),
    gutter: 0.7em,
    [
      #table(
        columns: (1.2fr, 1.5fr),
        inset: 5pt,
        stroke: 0.35pt,
        align: horizon,
        table.header([*MHz*], [*Uso*]),
        [430,000--432,000], [todos os modos],
        [432,000--432,025], [CW; EME],
        [432,025--432,420], [DX/EME/pilotos/ACDS por subfaixa],
        [432,420--433,000], [CW, SSB e digitais],
        [433,000--433,050], [ACDS],
        [433,050--433,150], [IVG],
        [433,150--434,000], [todos os modos],
        [434,000--435,000], [*Entrada de repetidoras*],
        [*435,000--438,000*], [*SAT exclusivo*],
        [438,000--439,000], [todos os modos],
        [439,000--440,000], [*Saída de repetidoras*],
      )
    ],
    [
      #set text(size: 17pt)
      *Notas:*
      - Janela SAT de 3 MHz (3× maior que a de 2 m): vários cubesats FM/SSB/digitais.
      - *Doppler é significativo em 70 cm*: $ Delta f_max approx 437 dot ("7,5"/3 dot 10^5) approx plus.minus$ 10,9 kHz, várias larguras SSB. Em 2 m cabe dentro do canal FM.
      - Repetidoras de 70 cm: entrada 434--435 MHz, saída 439--440 MHz; offset de 5 MHz.
      - #text(size: 12pt)[Resumo didático: modos e aplicações variam por subfaixa; consulte o #link("https://informacoes.anatel.gov.br/legislacao/atos-de-requisitos-tecnicos-de-gestao-do-espectro/2024/1919-ato-926")[Ato Anatel 926/2024] para operação real.]
      - Antena Yagi de 70 cm é interessante: elementos curtos (\~34 cm totais) cabem em cima da mesa.
    ],
  )
]

// ============================================================
// SLIDE 11 — Maxwell e equação da onda
// ============================================================
#slide[
  == De Maxwell à equação da onda

  #set text(size: 16pt)
  #grid(
    columns: (2fr, 0.6fr),
    gutter: 1em,
    [
      Quatro equações, em forma diferencial:
      #align(center)[
        #set text(size: 14pt)
        $ nabla dot bold(D) = rho quad quad nabla times bold(E) = - (partial bold(B))/(partial t) $
        $ nabla dot bold(B) = 0 quad quad nabla times bold(H) = bold(J) + (partial bold(D))/(partial t) $

        no vácuo: $quad bold(D) = epsilon_0 bold(E) quad$ e $quad bold(B) = mu_0 bold(H)$
      ]
      Em região livre de fontes ($rho = 0$, $bold(J) = 0$), tomando o rotacional da lei de Faraday e substituindo a de Ampère-Maxwell:
      #align(center)[
        $ nabla^2 bold(E) - mu_0 epsilon_0 (partial^2 bold(E))/(partial t^2) = 0 $
      ]
      - Equação da onda em 3D com velocidade $c = 1\/sqrt(mu_0 epsilon_0) approx 3 dot 10^8$ m/s.
      - É a base de toda a teoria de antenas; cargas aceleradas geram estas ondas.
    ],
    [
      // Figura: Ícones esquemáticos de esfera com carga (Gauss para E), superfície fechada (Gauss para B), loop com E e B variável no tempo (Faraday), loop com H cercando correntes J e corrente de deslocamento (Ampère-Maxwell).
      #align(center)[
        #image("fig/eletromag03_pg3.svg", height: 75%)
        #v(-0.6em)
        #text(size: 8pt)[Staelin, _MIT 6.013 Electromagnetics and Applications_, lecture 3, obtido de #link("https://ocw.mit.edu/courses/6-013-electromagnetics-and-applications-spring-2009/resources/mit6_013s09_lec03/")[ocw.mit.edu].]
      ]
    ],
  )
]

// ============================================================
// SLIDE 12 — Onda plana uniforme e Poynting
// ============================================================
#slide[
  == Onda plana uniforme, $eta_0$ e Poynting

  #set text(size: 17pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      Solução mais simples da equação da onda \ (no vácuo):
      #align(center)[
        $ bold(E)(z,t) = hat(x) E_0 cos(omega t - k z) $
        $ bold(H)(z,t) = hat(y) (E_0/eta_0) cos(omega t - k z) $
      ]
      - $bold(E) perp bold(H) perp bold(k)$, ambas em fase; $k = omega/c = 2 pi / lambda$.
      - *Impedância do vácuo*: $eta_0 = sqrt(mu_0 / epsilon_0) approx 377 Omega$.
      - *Vetor de Poynting*: $bold(S) = bold(E) times bold(H)$ em W/m² indica direção e magnitude do fluxo de potência.
      - Valor médio: $chevron.l bold(S) chevron.r = 1/2 "Re"{bold(E) times bold(H)^*}$.
    ],
    [
      // Figura: onda plana uniforme em 3D mostrando campo elétrico E oscilando em y (vermelho), campo magnético H oscilando em x (azul), ambos em fase, propagando no sentido +z; abaixo, curvas sobrepostas da densidade de energia elétrica e magnética, com picos coincidentes no mesmo z, ambas sempre positivas.
      #align(center)[
        #image("fig/eletromag03_pg7.svg", width: 100%)
        #v(-0.6em)
        #text(size: 8pt)[Staelin, _MIT 6.013 Electromagnetics and Applications_, lecture 3, obtido de #link("https://ocw.mit.edu/courses/6-013-electromagnetics-and-applications-spring-2009/resources/mit6_013s09_lec03/")[ocw.mit.edu].]
      ]
    ],
  )
]

// ============================================================
// SLIDE 13 — λ, dimensões elétricas, campo próximo vs distante
// ============================================================
#slide[
  == $lambda$, dimensões elétricas e campo próximo vs. distante

  #set text(size: 16pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.8em,
    [
      - $lambda = c/f$: em 145,8 MHz, $lambda approx$ 2,06 m.
      - Antenas são projetadas em *frações de* $lambda$: comprimento físico em metros não diz muito.
      - Para antenas pequenas, campo próximo reativo ($r lt.double lambda/(2 pi)$): termos $1/r^2$ e $1/r^3$ dominam; energia *armazenada*, não radiada.
      - Para antenas grandes, a região reativa cresce com $D$; campo distante exige $r gt.double lambda, D$ e, para Fraunhofer, $r gt 2D^2/lambda$.
      - Na transição, as duas regiões se misturam; por isso o entorno próximo de uma antena parece "circuito" e o longe "onda".

      #text(size: 14pt)[*Exemplo:* a $f = $ 145,8 MHz, a fronteira $lambda/(2 pi)$ fica a $approx$ 33 cm. Dentro dessa distância, o que parece "campo" interage com o próprio radiador.]
    ],
    [
      // Figura: antena no centro com duas regiões radiais: campo próximo r << lambda/(2pi), dominado por termos reativos 1/r^2 e 1/r^3, e campo distante r >> lambda/(2pi), dominado por termos radiados 1/r. Incluir exemplo numérico: lambda/(2pi) approx 33 cm em 145,8 MHz.
      #align(center)[#image("fig/campo_proximo_distante.svg", width: 100%)]
    ],
  )
]

// ============================================================
// SLIDE 14 — Como antenas radiam
// ============================================================
#slide[
  == Como antenas radiam

  #set text(size: 17pt)
  #grid(
    columns: (2fr, 1fr),
    gutter: 0.8em,
    [
      - Correntes (cargas em movimento) em um condutor geram potenciais *retardados*:
      #align(center)[
        $ bold(A)(bold(r), omega) = mu_0/(4pi) integral_V bold(J)(bold(r'), omega) e^(-j k r_(p q))/r_(p q) d V' $
        $ r_(p q) = |bold(r) - bold(r')| $
      ]
      - O termo $e^(-j k r_(p q))$ representa *atraso*; termos radiados decaem como $1/r$ e dominam no campo distante.
      - Em baixíssima frequência ($r_(p q) lt.double lambda/(2 pi)$), o atraso é desprezível e recuperamos os campos estáticos: _lumped_ (capacitor, indutor).
      - *Radiar é "arrancar" uma fração da energia do campo próximo e deixá-la ir embora*. Em termos de circuito, isso vira uma resistência equivalente: a *resistência de radiação* $R_r$.
    ],
    [
      // Figura: diagrama da geometria de radiação: volume fonte V_q com densidade de corrente J e carga rho em r_q; observador em r_p; vetor r_pq conectando fonte ao observador.
      #align(center)[
        #image("fig/eletromag18_pg1.svg", width: 90%)
        #v(-0.6em)
        #text(size: 8pt)[Staelin, _MIT 6.013 Electromagnetics and Applications_, lecture 18, obtido de #link("https://ocw.mit.edu/courses/6-013-electromagnetics-and-applications-spring-2009/resources/mit6_013s09_lec18/")[ocw.mit.edu].]
      ]
    ],
  )
]

// ============================================================
// SLIDE 15 — Dipolo de Hertz
// ============================================================
#slide[
  == Dipolo de Hertz: o protótipo analítico

  #set text(size: 16pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.8em,
    [
      - Fio infinitesimal de comprimento $d lt.double lambda$ com corrente $I_0 e^(j omega t)$ concentrada.
      - Campo distante:
      #align(center)[
        #set text(size: 14pt)
        $ E_theta = j (k I_0 d eta_0 sin theta)/(4 pi r) e^(-j k r) $
      ]
      - Padrão de *potência* $prop sin^2 theta$: máximo perpendicular ao dipolo, nulo ao longo do eixo.
      - Ganho máximo isotrópico: $G_0 = $ 1,5 (≈ 1,76 dBi).
      - Potência radiada: $P_T = 1/2 |I_0|^2 R_r$ com \ $R_r = 2 pi eta_0 / 3 (d/lambda)^2$.
      - *$R_r$ é proporcional a* $(d/lambda)^2$: se a antena é muito pequena frente a $lambda$, $R_r$ vira minúsculo.
    ],
    [
      // Figura: padrão de radiação do dipolo de Hertz no plano E, em forma de "oito" deitado: dois lóbulos simétricos com máximo em theta = 90° (perpendicular ao eixo do dipolo) e zero em theta = 0° e 180°. Círculo tracejado no centro representa radiador isotrópico de referência. Eixo vertical passa pelo dipolo.
      #align(center)[
        #image("fig/eletromag18_pg4.svg", width: 100%)
        #v(-0.6em)
        #text(size: 8pt)[Staelin, _MIT 6.013 Electromagnetics and Applications_, lecture 18, obtido de #link("https://ocw.mit.edu/courses/6-013-electromagnetics-and-applications-spring-2009/resources/mit6_013s09_lec18/")[ocw.mit.edu].]
      ]
    ],
  )
]

// ============================================================
// SLIDE 16 — Dipolo curto real
// ============================================================
#slide[
  == Dipolo curto real: corrente triangular e $R_r$ pequeno

  #set text(size: 15pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      - Um dipolo físico de comprimento $d$, alimentado no centro, comporta-se como *linha TEM aberta truncada*.
      - A corrente cai a zero nas pontas: distribuição aproximadamente *triangular*.
      - O dipolo curto radia como se tivesse *comprimento efetivo* $d_"eff" approx d/2$.
      - $R_r$ efetivo:
      #align(center)[
        #text(size: 15pt)[$ R_r approx eta_0 pi / 6 (d/lambda)^2 approx 20 pi^2 (d/lambda)^2 Omega $]
      ]
      - *Exemplo didático*: dipolo de 2 m em 1 MHz ⇒ $d/lambda = 2/300$ ⇒ $R_r approx$ 0,0088 $Omega$.
      - Também há reatância grande e negativa (capacitiva): $X approx -X_C$ da "linha truncada".
    ],
    [
      // Figura: dipolo curto centro-alimentado com distribuição de corrente I(z) triangular: máxima no centro (ponto de alimentação), zero nas duas extremidades. Acima do dipolo, um esboço simplificado do campo irradiado em direção ao observador distante a distância r, enfatizando r >> d.
      #align(center)[
        #image("fig/eletromag18_pg6.svg", width: 100%)
        #v(-0.6em)
        #text(size: 8pt)[Staelin, _MIT 6.013 Electromagnetics and Applications_, lecture 18, obtido de #link("https://ocw.mit.edu/courses/6-013-electromagnetics-and-applications-spring-2009/resources/mit6_013s09_lec18/")[ocw.mit.edu].]
      ]
    ],
  )
]

// ============================================================
// SLIDE 17 — Diretividade, ganho, abertura, polarização
// ============================================================
#slide[
  == Diretividade, ganho, abertura efetiva, polarização

  #set text(size: 15pt)
  #grid(
    columns: (2fr, 1fr),
    gutter: 0.8em,
    [
      - *Diretividade* $D(theta, phi)$: intensidade radiada em $(theta,phi)$ / média isotrópica.
      - *Ganho* $G(theta, phi) = eta_r dot D(theta, phi)$, com $eta_r$ = eficiência de radiação.
      - Para antena de feixe estreito:
      #align(center)[
        $ G_0 approx (4 pi) / Omega_B $
      ]
      onde $Omega_B$ é o ângulo sólido do lóbulo principal.
      - *Abertura efetiva*: $A_e (theta, phi) = G(theta, phi) dot lambda^2 / (4 pi)$ (casada e copolarizada).
      - *Polarização*: direção do vetor $bold(E)$. Linear (H ou V), circular (RHC/LHC), elíptica. Descasamento de polarização custa dB no orçamento de enlace.
      - Dipolo horizontal ⇔ linear horizontal; \ hélice axial ⇔ circular.
    ],
    [
      // Figura com dois painéis. Painel superior, isotrópico: ilustração 3D de um sistema de coordenadas esféricas. Uma esfera está centrada na origem, com eixos x, z e um eixo y sem rótulo. O vetor radial é "r". O ângulo a partir do eixo z é "theta", e o ângulo a partir do eixo x no plano xy é "phi". Um pequeno elemento de superfície destacado na esfera é indicado. Uma linha aponta para esse elemento com o texto "area = (r dtheta)(r sin theta dphi)". Outra linha aponta para o ângulo sólido subtendido por esse elemento, rotulado como "dOmega steradians". Um vetor tracejado apontando para fora através do elemento é rotulado como "I(theta, phi, r)". Painel inferior, padrão de antena: padrão de radiação polar. Um grande lóbulo elíptico aponta para cima e para a direita e está identificado como "main beam"; dentro dele há uma linha tracejada marcada como "I(theta, phi, r)". Uma marcação transversal dentro do feixe principal está rotulada como "Omega_B steradians", indicando o ângulo sólido associado ao lóbulo principal. Lóbulos laterais menores partem da origem e estão identificados como "sidelobes". Um lóbulo muito pequeno aponta na direção oposta ao feixe principal e está identificado como "backlobes".
      #align(center)[
        #image("fig/eletromag17_pg3.svg", height: 75%)
        #v(-0.6em)
        #text(size: 8pt)[Adaptado de Staelin, _MIT 6.013 Electromagnetics and Applications_, lecture 17, obtido de #link("https://ocw.mit.edu/courses/6-013-electromagnetics-and-applications-spring-2009/resources/mit6_013s09_lec17/")[ocw.mit.edu].]
      ]
    ],
  )
]

// ============================================================
// SLIDE 18 — Antena como circuito: R_r + jX
// ============================================================
#slide[
  == A antena vista como circuito: $R_r + j X$

  #set text(size: 15pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      Equivalente de Thévenin nos terminais da antena:

      #align(center)[
        $ Z_A = R_r + R_d + j X $
      ]

      - $R_r$: *resistência de radiação* (potência que vira onda).
      - $R_d$: *perdas ôhmicas/dielétricas* (condutor, balun, solo, matching).
      - $j X$: *reatância* devido à energia armazenada no campo próximo.
      - *Eficiência de radiação*:
      #align(center)[
        $ eta_r = R_r / (R_r + R_d) $
      ]
      - $R_r$ e $R_d$ são indistinguíveis do gerador; mas $R_r$ vira onda distante, $R_d$ vira calor.
    ],
    [
      // Figura: circuito equivalente de antena vista do gerador: fonte de Thévenin V_Th em série com resistência de radiação R_r, resistência de perdas R_d e reatância jX; os três juntos formam a impedância Z_A apresentada aos terminais de alimentação. A carga conectada é o restante do sistema (cabo, radio).
      #align(center)[
        #image("fig/eletromag17_pg7.svg", width: 90%)
        #v(-0.6em)
        #text(size: 8pt)[Staelin, _MIT 6.013 Electromagnetics and Applications_, lecture 17, obtido de #link("https://ocw.mit.edu/courses/6-013-electromagnetics-and-applications-spring-2009/resources/mit6_013s09_lec17/")[ocw.mit.edu].]
      ]
    ],
  )
]

// ============================================================
// SLIDE 19 — De onde vêm L e C da antena?
// ============================================================
#slide[
  == De onde vêm o "L" e o "C" da antena?

  #set text(size: 16pt)

  - O modelo RLC *não é uma imposição*: é o que sobra quando integramos Poynting para dentro do volume da antena.
  - *Reatância* $X$ vem do *desequilíbrio entre energia armazenada em $bold(E)$ e em $bold(H)$* no campo próximo:
    - Predomínio elétrico ⇒ $X < 0$ (capacitivo).
    - Predomínio magnético ⇒ $X > 0$ (indutivo).
  - Em *ressonância* de uma porta, $X approx 0$: no modelo equivalente, as parcelas reativas se cancelam em média.
  - *Simuladores* (PyNEC, OpenEMS) não precisam postular $L$ ou $C$: eles resolvem Maxwell em toda a geometria e apresentam $Z_A (omega)$ como resultado. O "RLC" é uma forma de *aproximar localmente* o comportamento em torno de uma frequência.

  #v(0.4em)
  #text(size: 14pt)[Pedagogicamente, $R_r + j X$ é uma *descrição em uma porta*, não uma descrição de componentes físicos dentro da antena.]
]

// ============================================================
// SLIDE 20 — Curto ⇒ capacitivo; Longo ⇒ indutivo
// ============================================================
#slide[
  == Antena curta $=>$ capacitiva; longa $=>$ indutiva

  #set text(size: 16pt)
  #grid(
    columns: (1.2fr, 1fr),
    gutter: 0.8em,
    [
      Pensando no dipolo como *linha TEM aberta truncada*:
      - Se $d < lambda/2$: a linha não completa meio ciclo antes de abrir. As pontas acumulam carga ⇒ *dominância de campo elétrico* ⇒ *capacitivo* ($X < 0$).
      - Se $d approx lambda/2$: primeira ressonância; em dipolos finos reais, tipicamente em $d approx$ 0,47--0,48 $lambda$. $R_r approx 73 Omega$, $X approx 0$.
      - Se $lambda/2 < d < lambda$: corrente ainda positiva em todo o fio mas o comprimento "extra" armazena mais energia magnética ao longo do condutor ⇒ *indutivo* ($X > 0$).
      - Se $d approx lambda$: modo de ordem superior/anti-ressonância; a impedância e o padrão mudam muito.

      Consequência prática: antenas "encolhidas" (_short verticals_ de 160 m, antenas de HT) são sempre capacitivas; antenas "longas demais" para a banda são indutivas.
    ],
    [
      // Figura: gráfico qualitativo da impedância Z_A de um dipolo em função do comprimento d / lambda. Eixo horizontal: d/lambda de 0 a 1. Duas curvas: R_r parte de zero, sobe suavemente, passa por ~73 ohms em d/lambda = 0,5 e sobe rapidamente; X começa em -infinito, cruza zero em d/lambda ~ 0,48 (ressonância), sobe a valores positivos e muda rapidamente perto de 1 (anti-ressonância/impedância alta no centro). Região "capacitiva" sombreada à esquerda do primeiro zero; região "indutiva" depois dele.
      #align(center)[#image("fig/dipolo_impedancia_qualitativa.svg", width: 100%)]
    ],
  )
]

// ============================================================
// SLIDE 21 — Casamento externo penaliza eficiência
// ============================================================
#slide[
  == Casamento externo: por que a eficiência cai?

  #set text(size: 15pt)
  Antena curta capacitiva: podemos pôr um *indutor em série* que cancele $X_C$. A impedância na entrada fica puramente resistiva, e um trafo casa com 50 $Omega$.

  *Problema:* $R_r$ permanece minúsculo. A eficiência verdadeira é
  #align(center)[
    $ eta_r = R_r / (R_r + R_"bobina" + R_"trafo" + R_"solo") $
  ]
  E o indutor real tem $Q$ finito: $R_"bobina" = omega L / Q$. Com $R_r = $ 0,02 $Omega$ e $R_"bobina" = $ 2 $Omega$, $eta_r < 1 %$.

  *O mesmo vale para antena longa indutiva*, com um capacitor externo: o $Q$ do capacitor é bem maior, porém $R_r$ no ponto de alimentação pode ser alto e reativo. Potência em $R_r$ representa potência radiada.

  *Bandwidth também paga o preço:* $Q_L$ alto ⇒ $"BW" = f_0 / Q_L$ pequena. Antena eletricamente curta só é bem casada em uma pequena janela de frequência.

  #text(size: 14pt)[Regra prática: para HF portátil, TX 100 W + antena de 1,5 m em 7 MHz pode radiar no máximo 5--20%, mesmo com bobina e contrapeso bem feitos.]
]

// ============================================================
// SLIDE 22 — Onde estão as perdas na prática?
// ============================================================
#slide[
  == Onde ocorrem as perdas na prática cotidiana?

  #set text(size: 15pt)
  #table(
    columns: (1.2fr, 2fr),
    inset: 4pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Situação*], [*Onde vaza*]),
    [Dipolo $lambda/2$ bem ajustado], [Perdas mínimas; quase só $R_r$. Cabo coaxial pode dominar em enlaces longos (HF em 10 MHz, cabo RG-58 de 50 m → $approx$ 2 dB).],
    [Antena eletricamente curta casada com _loading coil_], [*Bobina de carga* (skin effect no fio esmaltado, proximity effect, núcleo de ferrite saturando). Pode dissipar 70--90 % da potência.],
    [Vertical de quarter-wave sem radiais], [*Perdas no solo*: corrente de retorno passa por terra úmida → $R_"solo"$ de alguns a dezenas de ohms. Radiais reduzem drasticamente.],
    [Antena indoor em apartamento], [Acoplamento com fiação, armaduras, paredes: corrente de modo comum reflete no shack ou aquece condutores parasitas.],
    [Linha coaxial com ROE alta], [Reflexão no feedpoint vira onda estacionária; atenuação do cabo aumenta com ROE. Não é "perda extra", é o cabo dissipando mais da potência circulante.],
    [Yagi com casamento mal feito], [*Balun ausente*: corrente de modo comum no exterior do coaxial radia (e recebe) fora do padrão da antena.],
  )
]

// ============================================================
// SLIDE 23 — Ressonância e intuição por analogia TEM
// ============================================================
#slide[
  == Ressonância e a analogia com linha TEM

  #set text(size: 17pt)
  - Um *dipolo* pode ser visto como analogia de uma *linha TEM ressonante*: $X approx 0$ e $ cal(W)_e approx cal(W)_m $ em média.
  - Perto de *onda inteira* ($d approx lambda$), o centro fica próximo de nó de corrente: impedância alta e padrão multilobado.
  - *Array ressonante* (Yagi): os elementos parasitas não são "livres"; a ressonância deles é *forçada pelo campo do elemento ativo*. Cada parasita é um oscilador com $Q$ finito, sintonizado por *comprimento* e acoplado por *espaçamento*.
  - Por isso a Yagi depende de *comprimentos precisos*: pequenos ajustes mudam a fase da corrente induzida e, portanto, o padrão.
]

// ============================================================
// SLIDE 24 — Linha de transmissão: Z0, Γ, SWR
// ============================================================
#slide[
  == Linha de transmissão: $Z_0$, $Gamma$ e SWR

  #set text(size: 14pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.8em,
    [
      Linha ideal com *distribuição uniforme* de $L'$, $C'$ por metro:
      #align(center)[
        $ Z_0 = sqrt(L'/C') quad quad v_p = 1/sqrt(L' C') $
      ]
      - Coaxial típico: RG-58 tem $Z_0 = 50 Omega$, VF $approx$ 0,66 (reais incluem $R'$ e $G'$).
      - *Coeficiente de reflexão* no ponto de carga:
      #align(center)[
        $ Gamma_L = (Z_L - Z_0)/(Z_L + Z_0) $
      ]
      - *ROE (SWR)*:
      #align(center)[
        $ "SWR" = (1 + |Gamma|)/(1 - |Gamma|) $
      ]
      - Ao longo da linha, $|Gamma(z)| = |Gamma_L|$ (sem perdas), mas a *fase* gira 360° a cada $lambda/2$.
    ],
    [
      // Figura: modelo distribuído de linha TEM: séries de indutores L' dz e capacitores paralelos C' dz espalhados ao longo do comprimento, entre dois condutores paralelos. Abaixo, o mesmo circuito em geometria física: dois fios paralelos, placas paralelas, e corte de coaxial, todas três com a mesma topologia LC distribuída.
      #align(center)[
        #image("fig/eletromag11_pg5.svg", width: 80%)
        #v(-0.6em)
        #text(size: 8pt)[Staelin, _MIT 6.013 Electromagnetics and Applications_, lecture 11, obtido de #link("https://ocw.mit.edu/courses/6-013-electromagnetics-and-applications-spring-2009/resources/mit6_013s09_lec11/")[ocw.mit.edu].]
      ]
    ],
  )
]

// ============================================================
// SLIDE 25 — Linha como transformador
// ============================================================
#slide[
  == Linha como transformador de impedância

  #set text(size: 16pt)
  Ao longo de uma linha *propositalmente descasada*, a impedância vista varia com a posição:

  #align(center)[
    $ Z(-ell) = Z_0 (Z_L + j Z_0 tan k ell)/(Z_0 + j Z_L tan k ell) $
  ]

  Casos úteis:
  - $ell = lambda/4$: *transformador quarto-de-onda*: $Z_"in" = Z_0^2 / Z_L$. Para casar 50 $Omega$ a 112 $Omega$ (Delta Loop), usar 75 $Omega$ ($sqrt(50 dot 112) approx 75$).
  - $ell = lambda/2$: $Z_"in" = Z_L$ (espelho) na frequência considerada.
  - Stub curto-circuitado ou aberto: reatância pura sintetizável na frequência de interesse. Base do _hairpin match_ (próximos slides).

  #text(size: 14pt)[_Referência prática_: #link("https://youtu.be/G5qw83fbJ5Y")[Jobim, Coaxial 75Ω @ 1/4λ]. _Teoria_: #link("https://ocw.mit.edu/courses/6-013-electromagnetics-and-applications-spring-2009/resources/mit6_013s09_lec13/")[_MIT 6.013 Electromagnetics and Applications_, lecture 13].]
]

// ============================================================
// SLIDE 26 — Ladder line vs coaxial
// ============================================================
#slide[
  == Ladder line vs. coaxial

  #set text(size: 15pt)
  #table(
    columns: (0.7fr, 1.1fr, 1.1fr),
    inset: 4pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Aspecto*], [*Coaxial*], [*Ladder line / open-wire*]),
    [$Z_0$ típico], [50 $Omega$ (RG-58, RG-213), 75 $Omega$ (RG-11)], [300--600 $Omega$],
    [Atenuação (10 MHz)], [\~0,05 dB/m (RG-58) a \~0,02 dB/m (RG-213)], [\~0,001--0,003 dB/m; perdas dielétricas mínimas],
    [Blindagem], [Excelente em modo diferencial; campo confinado], [Nenhuma; radia pouco se balanceada e afastada],
    [Tolerância a ROE alta], [Ruim: perdas crescem rápido com $|Gamma|$], [Excelente: até SWR 10:1 perde pouco],
    [Uso típico], [Qualquer antena casada em 50 $Omega$: \ Yagi VHF/UHF, dipolo + balun], [*Antenas multibanda não-ressonantes* (doublet, G5RV, Zepp) + *acoplador* na estação],
    [Instalação], [Passa por janela sem problemas; qualquer curva], [*Precisa afastar 10 cm* de estruturas metálicas; curvas abertas],
  )

  #v(0.3em)
  #text(size: 13pt)[*Quando usar ladder line?* HF multibanda com acoplador na estação: uma única antena cobre 80--10 m com SWR alta na linha, mas a baixa atenuação compensa. Em VHF/UHF coaxial ganha: antenas são ressonantes e linhas são curtas.]
]

// ============================================================
// SLIDE 27 — MoM / NEC2 (ideia geral)
// ============================================================
#slide[
  == MoM e NEC2: como um simulador de antenas funciona

  #set text(size: 16pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.8em,
    [
      - *Problema*: dada a geometria de uma antena metálica (fios e superfícies condutoras), encontrar a corrente em cada ponto quando se aplica uma tensão nos terminais.
      - *Equação de partida*: Electric Field Integral Equation (EFIE) — condição de que $bold(E)_"tangencial" = 0$ na superfície do condutor perfeito.
      - Resultado: $bold(E)_"inc" = cal(L)(bold(J)_s)$, onde $cal(L)$ é um operador integral com núcleo baseado na função de Green do espaço livre ($e^(-j k r)/r$).
      - *Método dos Momentos (MoM)*: transformamos a equação integral em um sistema linear finito.
      - *PyNEC / NEC2++*: implementam MoM para fios finos (e algumas superfícies), com aproximação senoidal/pulso+cosseno por segmento.
    ],
    [
      // Figura: geometria para EFIE mostrando região 1 com fonte J incidente, obstáculo condutor com superfície S delimitada pela normal n; o desconhecido é a densidade superficial de corrente J_s induzida em S. O campo total tangencial em S deve ser zero para condutor perfeito: E_inc + E_espalhado(J_s) = 0.
      #align(center)[#image("fig/efie_geometria.svg", width: 100%)]
    ],
  )
]

// ============================================================
// SLIDE 28 — NEC2: discretização em segmentos
// ============================================================
#slide[
  == NEC2: discretização, matriz $Z$ e resolução

  #set text(size: 16pt)
  + *Segmentação*: o fio é dividido em $N$ segmentos de comprimento $Delta$ (tipicamente $Delta <= lambda/10$; raio $a$ com $Delta/a > 8$ para o núcleo _thin-wire_).
  + *Expansão*: $bold(J)(s) = sum_n alpha_n f_n (s)$, com $f_n$ base (pulso + seno + cosseno no NEC2).
  + *Teste (point-matching)*: aplica-se $bold(E)_"inc" = cal(L)(bold(J)_s)$ no centro de cada segmento.
  + *Sistema linear*: $bold(Z) dot bold(alpha) = bold(V)_"inc"$. A matriz $bold(Z)$ é a *matriz de impedância mútua*: $Z_(m n)$ quantifica o acoplamento entre os segmentos $m$ e $n$.
  + *Solução*: $bold(alpha) = bold(Z)^(-1) bold(V)$. Custo $O(N^3)$, memória $O(N^2)$.
  + *Pós-processamento*: impedância de entrada, ganho, padrão de radiação, eficiência.

  #v(0.3em)
  #text(size: 13pt)[*Por que isso funciona bem para Yagi?* A Yagi é poucos fios finos: $N$ pequeno, solução rápida, resposta exata para o modelo. Perfeito para otimizar comprimentos e espaçamentos.]
  #text(size: 13pt)[_Fundamentação_: _MIT 6.635 Advanced Electromagnetism_, #link("https://ocw.mit.edu/courses/6-635-advanced-electromagnetism-spring-2003/resources/mar05/")[lecture 5] and #link("https://ocw.mit.edu/courses/6-635-advanced-electromagnetism-spring-2003/resources/mar10/")[lecture 6]\; #link("https://apps.dtic.mil/sti/tr/pdf/ADA956129.pdf")[_manual do NEC2_].]
]

// ============================================================
// SLIDE 29 — FDTD / OpenEMS
// ============================================================
#slide[
  == FDTD e OpenEMS: simulação por grade de Yee

  #set text(size: 15pt)
  #grid(
    columns: (1.2fr, 1fr),
    gutter: 0.8em,
    [
      - *FDTD* (_Finite-Difference Time-Domain_): discretiza *diretamente* Maxwell na forma diferencial.
      - Grade de Yee: componentes de $bold(E)$ nas *arestas* das células, componentes de $bold(H)$ nas *faces*, intercaladas no espaço e no tempo (leapfrog).
      - Integra $nabla times bold(E) = -(partial bold(B))/(partial t)$ e $nabla times bold(H) = bold(J) + (partial bold(D))/(partial t)$ passo a passo.
      - *Limite de Courant* (passo de tempo): \ $c Delta t <= 1/sqrt((1/(Delta x))^2 + (1/(Delta y))^2 + (1/(Delta z))^2)$.
      - *Vantagem*: cobre a banda excitada pelo pulso e válida pela malha; lida com dielétricos complicados.
      - *Desvantagem*: domínio grande ⇒ muita memória; precisa de *PML* (_Perfectly Matched Layer_) nas bordas para simular espaço aberto.
    ],
    [
      // Figura: célula de Yee ilustrando uma cúbica com componentes Ex, Ey, Ez nas arestas e componentes Hx, Hy, Hz nas faces perpendiculares; os E ficam nos meios passos temporais t e os H nos meios passos t + dt/2, de modo que cada componente é atualizado a partir de rotacionais discretos dos vizinhos.
      #align(center)[#image("fig/celula_yee.svg", width: 100%)]
    ],
  )
]

// ============================================================
// SLIDE 30 — MoM vs FDTD
// ============================================================
#slide[
  == MoM vs. FDTD: quando usar cada um?

  #set text(size: 15pt)
  #table(
    columns: (1fr, 1.3fr, 1.3fr),
    inset: 4pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Critério*], [*MoM (NEC2, PyNEC)*], [*FDTD (OpenEMS, Meep)*]),
    [Equação], [Integral (EFIE); incógnitas nas correntes do condutor], [Diferencial; incógnitas em $bold(E)$ e $bold(H)$ em todo o volume],
    [Discretização], [Só o condutor; $N$ segmentos], [Todo o volume; $N_x times N_y times N_z$ células],
    [Bordas abertas], [Função de Green já inclui radiação], [*Precisa de PML* para simular espaço aberto],
    [Banda], [Uma frequência por rodada], [Todas simultaneamente (pulso + FFT)],
    [Bom para], [Fios finos no ar: dipolos, Yagis, verticais], [Estruturas volumétricas: dielétricos, antenas de patch, chips com trilhas],
    [Custo], [$O(N^3)$ memória quadrática, mas $N$ é pequeno], [Tempo proporcional a volume $times$ frequência máxima; muita RAM],
    [Tipicamente usado em], [*PyNEC*, *xnec2c*, *4nec2*, *MMANA-GAL*], [*OpenEMS*, *Meep*, CST Studio (comercial)],
  )
]

// ============================================================
// SLIDE 31 — Yagi: geometria
// ============================================================
#slide[
  == Yagi-Uda: geometria

  #set text(size: 15pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.8em,
    [
      - *Array endfire* de dipolos paralelos sobre um _boom_ (suporte) em linha reta.
      - *Um* elemento *ativo* (_driven_): ressonante em $approx lambda/2$ (tipicamente 0,47--0,48 $lambda$).
      - *Um* elemento *refletor*: $approx$ 5% mais longo que o ativo, atrás dele.
      - *$N$ diretores*: progressivamente mais curtos (primeiro 0,45 $lambda$, depois 0,43, 0,41, 0,40 $lambda$ ...), adiante do ativo.
      - Espaçamento típico entre elementos: 0,15--0,25 $lambda$.
      - Só o ativo é alimentado; refletor e diretores são *parasitas*, excitados pelo campo do ativo.
      - Feixe aponta na direção dos diretores (para a "frente").
    ],
    [
      // Figura: antena Yagi-Uda de 5 elementos em vista lateral. Um boom horizontal atravessa a figura; perpendicular a ele, da esquerda (traseira) para a direita (frente): refletor (mais longo), elemento ativo com ponto de alimentação destacado (dipolo dobrado), e três diretores progressivamente mais curtos. Setas indicam direção do feixe para a frente (direita) e dimensões de espaçamento 0,15--0,25 lambda. Polarização linear definida pela orientação dos elementos.
      #align(center)[#image("fig/yagi_uda_5_elementos.svg", width: 100%)]
    ],
  )
]

// ============================================================
// SLIDE 32 — Princípio de funcionamento da Yagi
// ============================================================
#slide[
  == Princípio: refletor indutivo, diretor capacitivo

  #set text(size: 15pt)
  Cada parasita é um *oscilador ressonante forçado* pelo campo do ativo. A fase da corrente induzida depende de estar *acima* ou *abaixo* da ressonância própria:

  #table(
    columns: (1fr, 1.3fr, 1.3fr),
    inset: 4pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Elemento*], [*Característica*], [*Efeito no feixe*]),
    [*Refletor* ($approx$ 1,05 $lambda/2$)], [Mais longo que ressonância ⇒ *indutivo*: corrente atrasa em fase], [A re-radiação reforça a soma para *frente* e cancela para *trás* ⇒ bom F/B],
    [*Ativo* ($approx lambda/2$)], [Ressonante, $X approx 0$; alimenta o conjunto], [Define a frequência de operação],
    [*Diretor* ($approx$ 0,95 $lambda/2$)], [Mais curto que ressonância ⇒ *capacitivo*: corrente adianta em fase], [Diretores bem otimizados reforçam o campo *para frente*],
  )

  #v(0.3em)
  - A distância entre elementos é crítica: o elemento parasita vê o campo do ativo *atrasado* pelo tempo de voo; somando-se a fase induzida pela reatância, chegamos à fase "certa" para reforçar o feixe frontal.
  - *Conclusão*: projetar Yagi é escolher *comprimentos* (reatâncias) e *espaçamentos* (atrasos) conjuntamente.
]

// ============================================================
// SLIDE 33 — Ganho × boom, workflow de projeto
// ============================================================
#slide[
  == Ganho vs. boom e métodos de projeto

  #set text(size: 15pt)
  #grid(
    columns: (1.2fr, 1fr),
    gutter: 0.8em,
    [
      Ganho depende de boom, elementos, espaçamento e otimização:
      - 2 el. (boom 0,1 $lambda$): ~ 5 dBi.
      - 3 el. (boom 0,3 $lambda$): ~ 7 dBi.
      - 5 el. (boom $approx$ 1 $lambda$): ~ 9--10 dBi.
      - 10 el. (boom $approx$ 3 $lambda$): ~ 13 dBi.
      - F/B típico: 15--25 dB; otimizáveis > 30 dB.

      *Métodos de projeto:*
      - #link("https://nvlpubs.nist.gov/nistpubs/Legacy/TN/nbstechnicalnote688.pdf")[*NBS Tech Note 688*] (Viezbicke, 1976): tabelas de elementos para 3--15 el.
      - #link("https://www.vk5dj.com/yagi.html")[*DL6WU*] (Günter Hoch): fórmulas iterativas para Yagis longas ($>2 lambda$).
      - *Otimização numérica* em #link("https://pypi.org/project/PyNEC/")[PyNEC] / #link("https://www.qsl.net/4nec2/")[4nec2] / #link("https://hamsoft.ca/pages/mmana-gal.php")[MMANA-GAL]: partir de NBS/DL6WU e otimizar ganho, F/B, SWR.
    ],
    [
      // Figura: gráfico G (dBi) vs. comprimento do boom em lambda, com curva quase logarítmica: 0,1 lambda ~ 5 dBi, 0,3 lambda ~ 7 dBi, 1 lambda ~ 9 dBi, 3 lambda ~ 13 dBi. Anotação: ordem de grandeza; dobrar o boom dá aproximadamente +3 dB.
      #align(center)[#image("fig/yagi_ganho_vs_boom.svg", width: 100%)]
    ],
  )
]

// ============================================================
// SLIDE 34 — Casamento Yagi
// ============================================================
#slide[
  == Casamento da Yagi à linha coaxial

  #set text(size: 14pt)
  Em muitas Yagis com dipolo simples, a impedância no feedpoint *cai para 20--30 $Omega$* (o acoplamento mútuo reduz $R_r$ aparente). Precisamos elevá-la para 50 $Omega$ e remover reatância.

  #table(
    columns: (0.9fr, 2fr),
    inset: 4pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Técnica*], [*Descrição*]),
    [*Dipolo dobrado*], [Substitui o ativo: impedância $approx 4 times$ a do dipolo simples. Em Yagi de baixa impedância pode cair em 80--120 $Omega$; se perto de 200 $Omega$, _balun_ 4:1 casa para 50 $Omega$.],
    [*Gamma match*], [Cilindro paralelo a meia-haste do ativo: vivo no gamma, malha no boom. Capacitor série ajusta reatância. Alimenta de modo assimétrico; choke ainda é recomendável.],
    [*Beta / Hairpin match*], [Ativo propositalmente *curto* ⇒ $Z_A = R - j X_C$. Um _stub_ curto-circuitado (_hairpin_) em paralelo fornece $+j X_L$ que cancela $X_C$; o conjunto paralelo eleva a parte real para 50 $Omega$.],
    [*Transformador $lambda/4$*], [Trecho de linha com $Z_T = sqrt(Z_"in" Z_L)$ entre ativo e coaxial. Ex.: 37 $Omega$ para casar 28 $Omega$ a 50 $Omega$ (raro achar cabo; emenda-se dois em paralelo).],
    [*Balun/choke*], [Necessário conforme a alimentação; reduz corrente de modo comum no exterior do coaxial. Detalhes em slide 36.],
  )
]

// ============================================================
// SLIDE 35 — Como a hairpin funciona
// ============================================================
#slide[
  == Como a _hairpin match_ funciona

  #set text(size: 14pt)
  #grid(
    columns: (1.3fr, 1fr),
    gutter: 0.7em,
    [
      + *Curtamos o ativo* um pouco abaixo da ressonância: \ $Z_A = R - j X_C$ com $R < 50 Omega$ (ex.: $R = 25 Omega$, $X_C = -30 Omega$).
      + Colocamos em paralelo um *stub curto-circuitado* de linha paralela, comprimento $approx lambda/20$, separação 2--5 cm. Esse stub apresenta reatância *indutiva* $+j X_L$.
      + A admitância combinada é
      #align(center)[
        $ Y_"total" = 1/(R - j X_C) + 1/(j X_L) $
      ]
      + Escolhendo $X_L$, cancela-se a parte imaginária; no exemplo, a parte real fica $approx 61 Omega$. Ajusta-se a geometria para 50 $Omega$.

      *Vantagem prática*: condutor rígido e grampos; sem capacitor variável, banda relativamente larga ($approx$ 5% de $f_0$). Ainda use choke para modo comum.
    ],
    [
      // Figura: esquema da hairpin match. Na parte de baixo, o elemento ativo da Yagi, ligeiramente curto (X_C representado por um capacitor pontilhado em série). Os dois terminais do ativo são ligados a duas hastes paralelas verticais, curtadas por um travessão no topo, formando um "U" invertido (a hairpin). Setas indicam impedância R_a - j X_C vista pelos terminais do ativo, e + j X_L vista pelos terminais do stub; ambas em paralelo somam para 50 ohms.
      #align(center)[#image("fig/hairpin_match.svg", width: 100%)]
    ],
  )
]

// ============================================================
// SLIDE 36 — Baluns
// ============================================================
#slide[
  == Baluns: sem eles, o casamento mente

  #set text(size: 15pt)
  - *Coaxial é desbalanceado*: no modo diferencial, condutor interno e face interna da malha levam correntes iguais e opostas.
  - *Dipolo é balanceado*: correntes nos dois braços devem ter mesma magnitude e fases opostas.
  - Conectar coaxial direto a dipolo: a corrente do condutor interno vai para um braço, mas a malha pode escoar para *três* lugares (interior da malha = outro braço + exterior da malha).
  - Corrente de modo comum no *exterior* da malha:
    - radia com padrão diferente ⇒ degrada F/B da Yagi.
    - recebe ruído do shack ⇒ piora S/N.
    - *mente para o NanoVNA*: a impedância medida reflete o sistema inteiro, não só a antena.
  - *Soluções*:
    - *Choke balun* (_common-mode choke_): ferrite ou cabo enrolado; depende de frequência, cabo, geometria e potência.
    - *1:1 current balun*: inibe modo comum; correntes ficam quase iguais.
    - *4:1 balun*: transforma impedância (útil em dipolo dobrado).
  - O próprio NanoVNA se usa para *verificar o choke* via $S_(21)$: bom choke mostra $>= 25$ dB de atenuação de *modo comum* nas frequências de operação.
]

// ============================================================
// SLIDE 37 — NanoVNA: o que mede
// ============================================================
#slide[
  == NanoVNA: o que ele mede

  #set text(size: 16pt)
  #grid(
    columns: (1.3fr, 1fr),
    gutter: 0.8em,
    [
      - *VNA = Vector Network Analyzer*: mede $bold(S)$-parâmetros *com fase* (amplitude + fase).
      - Duas portas:
        - *CH0 (REFL)*: injeta sinal e mede $S_(11)$ (reflexão) ⇒ impedância da DUT conectada.
        - *CH1 (THRU)*: mede $S_(21)$ (transmissão) através da DUT (requer ambas portas).
      - Faixa típica: 50 kHz a 900 MHz (H) ou 1,5 GHz (H4); fundamental até 300 MHz, depois harmônicas.
      - Potência de saída $approx$ -13 dBm. *Nunca* injetar RF externo na porta; *nunca* aplicar DC.
      - Formatos de exibição: $|S_(11)|$ em dB (return loss), fase, SWR, carta de Smith, parte real, parte imaginária, $|Z|$, $Q$.
    ],
    [
      // Figura: diagrama de blocos do VNA: oscilador interno alimenta um divisor que envia parte para a porta CH0 e parte para um receptor de referência. O sinal refletido pela DUT volta a outro receptor. Com CH1 conectado, outro receptor mede o sinal transmitido. Dois blocos "R0" e "R1" representam os receptores e um processador digital calcula S11 = refletido/incidente e S21 = transmitido/incidente.
      #align(center)[#image("fig/vna_diagrama_blocos.svg", width: 100%)]
    ],
  )
]

// ============================================================
// SLIDE 38 — Carta de Smith aplicada
// ============================================================
#slide[
  == Carta de Smith aplicada

  #set text(size: 16pt)
  #grid(
    columns: (1.1fr, 1fr),
    gutter: 0.7em,
    [
      Plano $Gamma$ de uma carga passiva, com $|Gamma| <= 1$, mapeado para $z = Z/Z_0$.

      Pontos-chave:
      - *Centro*: $Z = 50 + j 0$ (casado, $Gamma = 0$).
      - *Direita*: $Z = infinity$ (aberto, $Gamma = +1$).
      - *Esquerda*: $Z = 0$ (curto, $Gamma = -1$).
      - *Semicírculo superior*: indutivo ($X > 0$).
      - *Semicírculo inferior*: capacitivo ($X < 0$).
      - Ao varrer em frequência, o traço da antena *desenha uma curva*. Cruzar o eixo horizontal = *ressonância* ($X = 0$).

      *Leitura rápida* perto da primeira ressonância: metade *inferior* ⇒ curta/capacitiva; metade *superior* ⇒ longa/indutiva.
    ],
    [
      // Figura: carta de Smith impressa no display do NanoVNA com o traço de um dipolo de 2 m entre 140 e 150 MHz. A curva entra pelo semicírculo inferior (região capacitiva), cruza o eixo horizontal perto do centro ~145 MHz (ressonância), e sai para o semicírculo superior (região indutiva). Marcador destacado no cruzamento indica a frequência de ressonância.
      #align(center)[
        #image("fig/nanovna_seminario_video04_smith_2m.jpg", width: 90%)
        #v(-0.6em)
        #text(size: 8pt)[Haag, _Introdução à Carta de Smith_, obtido de #link("https://youtu.be/jt156tUd95Q?t=3948")[youtu.be].]
      ]

    ],
  )
]

// ============================================================
// SLIDE 39 — Calibração OSLT
// ============================================================
#slide[
  == Calibração SOLT/OSLT (com o cabo!)

  #set text(size: 15pt)
  O NanoVNA não "sabe" onde fica o plano de referência: a calibração SOLT/OSLT o define.

  + *Open*: conecte a peça de circuito aberto na ponta do cabo de teste, toque em `OPEN`.
  + *Short*: conecte a peça de curto-circuito, toque em `SHORT`.
  + *Load*: conecte a carga 50 $Omega$, toque em `LOAD`.
  + Para medidas $S_(21)$: também *Isolation* (carga nas duas portas) e *Thru* (direct entre CH0 e CH1).
  + `DONE` → `SAVE 0` (uma das 5 memórias).

  *Regra de ouro*: *calibre COM o cabo de teste conectado*. O plano de referência é transferido para a ponta distante do cabo.

  *Por que isso importa:* uma carga de 110 $Omega$ no fim de um cabo pode aparentar outra impedância se o plano de referência ficar no VNA; calibrando com o cabo, aparece corretamente na ponta distante.

  #text(size: 13pt)[Ref.: #link("https://youtu.be/FJLz-HTPb3Y?t=718")[Jobim, _Leitura da impedância na carga (antena)_].]
]

// ============================================================
// SLIDE 40 — Medindo antena: ressonância vs casamento
// ============================================================
#slide[
  == Medindo antena: ressonância $eq.not$ casamento

  #set text(size: 16pt)
  Dois conceitos independentes:
  - *Ressonância*: $X = 0$. Depende *só do comprimento* (e geometria).
  - *Casamento*: $Z = 50 + j 0$. Depende também da *forma de alimentação*.

  Pode-se ter ressonância *sem* bom SWR (ex.: Yagi antes de casar: 25 $Omega$ em ressonância ⇒ SWR $approx 2$).

  *Procedimento:*
  + Varrer a banda de interesse.
  + Identificar a frequência onde $X$ cruza zero (ponto da carta de Smith no eixo horizontal).
  + Se ressonância *acima* do alvo ⇒ antena está *curta* ⇒ alongar.
  + Se ressonância *abaixo* do alvo ⇒ antena está *longa* ⇒ encurtar.
  + Só *depois* de estar ressonante na frequência certa, atacar o casamento (hairpin, gamma, balun, $lambda/4$).

  #v(0.3em)
  #text(size: 13pt)[*Cuidado com o mito do $lambda/2$*: dipolo livre ressonante é $approx 73 Omega$, não 50 $Omega$. Yagi, vertical e dipolos próximos ao solo têm $R$ diferente.]
]

// ============================================================
// SLIDE 41 — TDR
// ============================================================
#slide[
  == TDR: comprimento do cabo e descontinuidades

  #set text(size: 14pt)
  O NanoVNA faz *TDR* (_Time-Domain Reflectometry_) por IFFT do $S_(11)$.

  #grid(
    columns: (1fr, 1fr),
    gutter: 0.7em,
    [
      *Configuração*:
      - `Display > Transform > LOW_PASS_IMPULSE` (pico por descontinuidade).
      - Alternativa: `LOW_PASS_STEP` (degrau: mostra impedância ao longo do cabo).
      - Ajustar *velocity factor* (VF) para o cabo:
        - RG-58 PE sólido: 0,66.
        - RG-8 foam: 0,78--0,83.
        - LMR-400: 0,85.
      - Varrer até algumas centenas de MHz.

      *Uso*:
      - Deixar ponta *aberta* ⇒ pico marca comprimento total.
      - Conectores e defeitos aparecem como picos menores intermediários.
    ],
    [
      *Limites*:
      - Ruptura de malha pode aparecer, dependendo do dano e da banda.
      - Resolução limitada pela banda do VNA: cabos curtíssimos (menores que 1 m) são difíceis.
      - Para medidas finas de perda, usar NanoVNA-App no PC (801 pontos) em vez do display interno (101--401 pontos).

      *Perda do cabo (estimativa rápida)*:
      - Aberto na ponta ⇒ $|S_(11)|$ em dB na banda.
      - Perda unidirecional $approx 1/2 |S_(11)|_"dB"$.
    ],
  )
]

// ============================================================
// SLIDE 42 — Z0 do cabo pelo método λ/8
// ============================================================
#slide[
  == Medindo $Z_0$ do cabo (método $lambda/8$)

  #set text(size: 16pt)
  Quando você não sabe se um cabo "50 $Omega$" é mesmo 50 $Omega$ (ou achou um pedaço antigo):

  + Deixe a ponta do cabo *aberta*.
  + Varra em frequência até identificar a *primeira* frequência $f_(lambda/4)$ em que o aberto vira curto na entrada (Smith à *esquerda*, mínimo de $|Z|$).
  + A meio caminho, $f_(lambda/8) = f_(lambda/4) \/ 2$: ajuste CW nessa frequência.
  + Nessa frequência, $|Z|$ lido na Smith é numericamente *igual a $Z_0$ do cabo*.

  *Exemplo* #link("https://youtu.be/bCmB7w4r15g")[Jobim, _Determinando Z0 do cabo coaxial_]: RG-11 testado pelo método mostra $|Z| = $ 74,6 $Omega$ (confirma nominal 75 $Omega$).

  *Variante*: plotar simultaneamente $S_(11)$ com ponta aberta e com ponta em curto; a interseção das curvas em $|Z|$ vs. $f$ ocorre em $|Z| = Z_0$.

  #v(0.3em)
  #text(size: 13pt)[*Por que funciona?* Em $lambda/8$, uma linha aberta ideal apresenta $Z = -j Z_0$, portanto $|Z| = Z_0$. É consequência direta da fórmula \ $Z(ell) = -j Z_0 cot(k ell)$.]
]

// ============================================================
// SLIDE 43 — Chokes, traps, filtros via S21
// ============================================================
#slide[
  == Chokes, traps e filtros via $S_(21)$

  #set text(size: 14pt)
  Para qualquer *dispositivo bilateral passivo*, medimos $S_(21)$ através dele:

  + Calibre incluindo OSLT + ISOLN + THRU.
  + Conecte DUT em série entre CH0 e CH1.
  + Trace `LogMag S21`, 10 dB/divisão.

  #grid(
    columns: (1fr, 1fr),
    gutter: 0.7em,
    [
      *Choke de modo comum:*
      - Curte vivo+malha em cada ponta para formar uma porta de modo comum e meça $S_(21)$ no arranjo de ensaio.
      - Boa performance: $>= 25$ dB de atenuação de modo comum, ou $Z_"CM"$ de centenas a milhares de ohms.
      - Verifique em *ambas* as bandas que o choke deve cobrir (ex.: 40 + 80 m).
      - *Objetos metálicos nas proximidades* deslocam a ressonância: teste no ambiente final.
    ],
    [
      *Trap LC paralelo (antena multibanda):*
      - Na ressonância do trap, $|S_(21)|$ cai a um mínimo profundo.
      - Ajuste ressonância abrindo/comprimindo as espiras.
      - Verifique $Q$ (largura do entalhe): Trap de baixo $Q$ amortece a antena.

      *Filtros / duplexers:*
      - Rejeição limitada pela faixa dinâmica do NanoVNA ($approx 70$--$80$ dB).
      - Para duplexadores de repetidora ($>90$ dB) precisa de VNA profissional.
    ],
  )
]

// ============================================================
// SLIDE 44 — Simulação vs medida
// ============================================================
#slide[
  == Simulação e medida: faces do mesmo fenômeno

  #set text(size: 15pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.7em,
    [
      *O que sai da simulação (NEC2/OpenEMS):*
      - $Z_A(f) = R(f) + j X(f)$ no ponto de alimentação.
      - Ganho, diretividade, padrão de radiação.
      - Distribuição de corrente nos segmentos.
      - Largura de banda onde SWR < 2.

      *O que o NanoVNA mede:*
      - $S_(11)(f)$ no ponto de alimentação (via cabo calibrado).
      - $Z_("in")(f) = Z_0 (1 + S_(11))/(1 - S_(11))$.
      - SWR($f$), Q, ressonância.
      - Exportável em `.s1p` para pós-processamento.
    ],
    [
      *Ponte:*
      - Simular antes de construir ⇒ economizar protótipos.
      - Medir depois de construir ⇒ validar o modelo.
      - *Discrepâncias comuns*: solo real, objetos metálicos próximos, balun ausente, comprimento do condutor real diferente da base de modelagem.
      - Choke: medir com VNA ou modelar ferrites; NEC não modela ferrite diretamente.
    ],
  )

  #v(0.3em)
  #text(size: 13pt)[_Procedimento didático_: exportar `.s1p` e comparar a curva medida com a simulada no pós-processamento.]
]

// ============================================================
// SLIDE 45 — Armadilhas comuns
// ============================================================
#slide[
  == Armadilhas comuns na prática

  #set text(size: 15pt)
  - *Cabo sem calibração*: a impedância lida é $Z_"antena"$ *transformada* pelo cabo; pode parecer casada quando não está. Calibre com o cabo.
  - *Ponta do cabo removida após calibração*: a calibração muda e a leitura vira "ruído" espiralado.
  - *Corrente de modo comum*: sem choke, a medição mistura antena + shield + ambiente.
  - *Fator de velocidade errado*: TDR retorna comprimento errado proporcionalmente.
  - *Potência de saída baixa*: em cabos muito longos ou com atenuador, a reflexão cai abaixo do piso de ruído ⇒ SWR "excelente" ilusório.
  - *Tolerância de componentes reais*: cabo "50 $Omega$" típico varia 48--52 $Omega$; conectores adicionam descontinuidades pequenas; ripple residual de até SWR 1,07 é normal.
  - *DC na porta*: NanoVNA queima. Use DC-block se medir próximo a TX.
  - *Carga de calibração desgastada*: confere zero; depois de um tempo, substituir.

  #v(0.3em)
  #text(size: 13pt)[A máxima do PY3PR: "não é a antena que _parece_ estar bem, é a antena que _está_ bem." Use os dois conceitos de ressonância e casamento *separadamente*.]
]

// ============================================================
// SLIDE 46 — Link budget: Friis e FSPL
// ============================================================
#slide[
  == Link budget: equação de Friis e FSPL

  #set text(size: 16pt)
  Potência recebida de um TX a distância $d$:
  #align(center)[
    $ P_r = P_t dot G_t dot G_r dot (lambda/(4 pi d))^2 $
  ]

  Em dB, decomposto em termos que podemos identificar um a um:
  #align(center)[
    $ P_r ["dBW"] = P_t - L_"tl,TX" + G_t - L_"FSPL" + G_r - L_"tl,RX" $
  ]

  A *perda de espaço livre (FSPL)* é geométrica:
  #align(center)[
    #text(size: 14pt)[$ L_"FSPL" = 20 log_10 (4 pi d / lambda) = 22.0 + 20 log_10(d/lambda) approx 32.45 + 20 log_10(d_"km") + 20 log_10(f_"MHz") $]
  ]

  *Intuição geométrica*: a potência $P_t$ se espalha sobre uma esfera de área $4 pi d^2$; a antena receptora coleta uma fração proporcional à sua *abertura efetiva* $A_e = G_r lambda^2/(4 pi)$.

  #text(size: 13pt)[Ref.: #link("https://iaru.amsat-uk.org/assets/AMSAT-IARU_Link_Model_Rev2.5.5.xls")[AMSAT, _Link Model spreadsheet_].]
]

// ============================================================
// SLIDE 47 — EIRP e cadeia de TX
// ============================================================
#slide[
  == PIRE (EIRP) e cadeia do transmissor

  #set text(size: 16pt)
  #align(center)[
    $ "EIRP"_"dBW" = P_t - L_"linha" + G_t $
  ]

  - *EIRP* = potência isotrópica equivalente: "quão forte uma fonte isotrópica emitiria para a mesma densidade no lóbulo principal".
  - *Exemplo AMSAT*: $P_t = 10$ W = 10 dBW; $L_"linha" = $ 3,6 dB (cabos + conectores + filtro + acoplador + VSWR); $G_t = $ 18,5 dBi (Yagi).
  #align(center)[
    #text(size: 15pt)[$ "EIRP" = 10 - "3,6" + "18,5" = "24,9" " dBW" approx 310 " W" $]
  ]
  - No receptor, a mesma decomposição mostra:
    - Perdas de *apontamento* (antena fora do eixo do satélite).
    - Perdas de *polarização* (circular ideal vs. linear ideal = 3 dB).
    - Perdas *atmosféricas* e *ionosféricas* (dependem de frequência e elevação).
    - Perdas de *chuva* em bandas SHF.
]

// ============================================================
// SLIDE 48 — Temperatura de ruído e G/T
// ============================================================
#slide[
  == Ruído do sistema: temperatura equivalente e G/T

  #set text(size: 14pt)
  Potência de ruído térmico na entrada do receptor (banda $B$):
  #align(center)[
    $ P_n = k T_s B quad ⇒ quad P_n["dBW"] = -"228,6" + 10 log_10(T_s) + 10 log_10(B) $
  ]

  $T_s$ = *temperatura equivalente* do sistema; combina ruído da antena (céu + solo), perdas de linha antes do LNA, e ruído do próprio LNA:
  #align(center)[
    #text(size: 14pt)[$ T_s = a dot T_a + (1-a) dot T_0 + T_"LNA" + T_"2ª etapa"/G_"LNA" $]
  ]
  com $a = 10^(-L_"pre-LNA"/10)$; $T_s$ é referido após essa perda e $T_0 approx 290$ K.

  *Figura de mérito da estação receptora*:
  #align(center)[
    $ G/T = G_a - L_"pre-LNA" - 10 log_10(T_s) quad ["dB/K"] $
  ]

  - Perdas *antes* do LNA degradam $T_s$ *diretamente* (viram ruído): cabo curto e LNA *na antena* são críticos.
  - Figura de ruído $"NF"$ (em dB): $F = 10^("NF"/10)$ e $T_e = T_0 (F - 1)$; $"NF" = 3$ dB $equiv$ 290 K.
]

// ============================================================
// SLIDE 49 — Eb/N0 por modulação e FEC
// ============================================================
#slide[
  == $E_b\/N_0$ típico por modulação e FEC

  #set text(size: 13pt)
  #table(
    columns: (1.3fr, 1.5fr, 0.7fr, 0.8fr),
    inset: 3.5pt,
    stroke: 0.35pt,
    align: horizon,
    table.header([*Modulação*], [*Codificação*], [*BER*], [*$E_b\/N_0$ (dB)*]),
    [AFSK/FM (1200 bps Bell 202)], [nenhuma], [$10^(-5)$], [23,2],
    [FSK G3RUH (9600 bps)], [nenhuma], [$10^(-5)$], [18,0],
    [FSK coerente], [nenhuma], [$10^(-5)$], [11,9],
    [GMSK], [nenhuma], [$10^(-5)$], [9,6],
    [BPSK / QPSK], [nenhuma], [$10^(-5)$], [9,6],
    [BPSK], [Conv. R=1/2 K=7 (Viterbi)], [$10^(-6)$], [4,8],
    [BPSK], [Conv. R=1/2 + *RS(255,223)*], [$10^(-6)$], [*2,5*],
    [BPSK], [Conv. R=1/6 K=15 + RS(255,223)], [$10^(-7)$], [0,8],
    [BPSK], [Turbo (downlink)], [$10^(-6)$], [0,75],
  )

  #v(0.3em)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.7em,
    [
      #set text(size: 14pt)
      Como aplicar:
      #align(center)[
        $ E_b/N_0 = C/N_0 - 10 log_10(R_b) $
        $ R_b = "taxa de bits" " [bit/s]" $
        // 228,6 = -10 log10(k_B), com k_B em W/(Hz K); por isso entra somando em dB.
        $ C/N_0 = "EIRP" + G/T - L_"path" - L_"outros" + "228,6" $
      ]
    ],
    [
      // Figura: curva canônica BER x Eb/N0 para BPSK ideal em escala semilogarítmica. Eixo Y: BER de 10^-9 a 10^-1 em log. Eixo X: Eb/N0 de 0 a 14 dB em linear. Curva decrescente; anotação "Pe = 0,5 erfc(sqrt(Eb/N0))". Marcadores em BER 10^-4 (8,4 dB) e BER 10^-8 (12 dB).
      #align(center)[
        #image("fig/amsat_bpsk_performance_curve.jpeg", width: 36%)
        #v(-1em)
        #text(size: 6pt)[AMSAT, _Link Model spreadsheet_, obtido de #link("https://iaru.amsat-uk.org/assets/AMSAT-IARU_Link_Model_Rev2.5.5.xls")[iaru.amsat-uk.org].]
      ]
      
    ],
  )
]

// ============================================================
// SLIDE 50 — Margem de enlace
// ============================================================
#slide[
  == Margem de enlace: verde, amarelo, vermelho

  #set text(size: 17pt)
  #align(center)[
    $ M = (E_b/N_0)_"obtido" - (E_b/N_0)_"limiar" $
  ]

  Classificação prática tipo AMSAT-IARU:
  #table(
    columns: (1fr, 1fr, 2fr),
    inset: 4pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Margem*], [*Status*], [*Interpretação*]),
    [$M < 0$ dB], [*Vermelho*], [Enlace não fecha],
    [$0 <= M < 6$ dB], [*Amarelo*], [Marginal: fecha em boa passagem, falha no geral],
    [$M >= 6$ dB], [*Verde*], [Fecha com margem de projeto padrão],
  )

  - Margem típica: *10 dB* baixo custo; *6 dB* profissional; depende da missão.
  - Cada *3 dB* extra permite usar *metade da potência TX* ou aumentar o alcance por *$sqrt(2)$*.
  - *FEC* reduz o $(E_b\/N_0)_"limiar"$. RS(255,k): ganho depende do canal e do padrão de erros.
]

// ============================================================
// SLIDE 51 — Doppler em LEO
// ============================================================
#slide[
  == Efeito Doppler em órbitas LEO

  #set text(size: 14pt)
  Velocidade orbital da ISS: $v_"orb" approx "7,5"$ km/s.

  Shift máximo na aproximação/afastamento (perto de AOS/LOS; no zênite $v_r approx 0$):
  #align(center)[
    $ Delta f = f dot v_r / c $
  ]

  #grid(
    columns: (1fr, 1fr),
    gutter: 0.7em,
    [
      Para ISS APRS a *145,825 MHz*:
      #align(center)[
        #text(size: 12pt)[$ Delta f_max approx "145,8" " MHz" dot 7500/(3 dot 10^8) approx plus.minus "3,6" " kHz" $]
      ]
      - Cabe dentro do canal FM (passa-faixa $approx 15$ kHz).
      - Correção Doppler geralmente dispensável em FM/AFSK.

      Para um satélite em UHF a *437 MHz*:
      #align(center)[
        #text(size: 12pt)[$ Delta f_max approx plus.minus "10,9" " kHz" $]
      ]
      - É várias larguras de canal SSB.
      - *Precisa* compensar Doppler (manualmente ou com software de rastreio).
    ],
    [
      // Figura: geometria de passagem de satélite em LEO sobre uma estação terrena. Arco da órbita da ISS de AOS (aquisição) passando por TCA (zênite) até LOS (perda de sinal). Em cada ponto, vetor velocidade v da ISS e sua projeção radial v_r em direção à estação. Gráfico abaixo: frequência recebida ao longo do tempo formando curva S: começa em f0 + Delta f_max (aproximação), cruza f0 no zênite, termina em f0 - Delta f_max (afastamento).
      #align(center)[#image("fig/leo_doppler_geometria.svg", width: 90%)]
    ],
  )
]

// ============================================================
// SLIDE 52 — QO-100: GEO muda a geometria
// ============================================================
#slide[
  == QO-100 (Es'hail-2): GEO muda a geometria do enlace

  #set text(size: 14pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.8em,
    [
      *QO-100* = transponder radioamador a bordo do *Es'hail-2*, satélite geoestacionário a $25.9° "E"$, altitude $approx 35 786$ km; distância no Brasil $approx 39$--$41$ mil km.

      Operacionalmente, o oposto da ISS:
      - *Sem janelas*: disponível 24/7 para quem está no footprint.
      - *Antena fixa*: aponta sempre para o mesmo azimute/elevação; nada de rastreio.
      - *Doppler geométrico desprezível*: $v_r approx 0$; a deriva de osciladores/LNB domina.
      - *Efeito ionosférico pequeno*: em SHF, chuva/gases e baixa elevação passam a importar.
      - *Footprint*: Europa, África, Oriente Médio, Índia até Tailândia, e *parte do Brasil* — a elevação cai rapidamente para oeste/sul.
    ],
    [
      *Elevação típica no Brasil* (azimute nordeste, $approx 50°$--$90°$):
      #table(
        columns: (1fr, 0.5fr, 1.1fr),
        inset: 3pt,
        stroke: 0.35pt,
        align: horizon,
        table.header([*Cidade*], [*Elev.*], [*Antena recomendada*]),
        [Natal / Recife], [$approx 20°$], [60 cm],
        [Salvador], [$approx 17°$], [60 cm],
        [Rio / Belo Horizonte], [$approx 10°$], [60--75 cm],
        [Brasília], [$approx 7°$], [60--75 cm],
        [São Paulo], [$approx 7°$], [60 cm opera; 75--90 cm recomendado],
        [Curitiba / Florianópolis], [$approx 4°$--$6°$], [$>=$ 90 cm, marginal],
        [Porto Alegre], [$approx 3°$], [muito marginal],
        [Manaus / Rio Branco], [$<= 0°$], [*abaixo do horizonte*],
      )

      #v(0.2em)
      #text(size: 11pt)[Há WebSDRs QO-100 ativos no Brasil (p.ex. Pardinho-SP, $approx$ $6°$ de elevação), confirmando operação prática no Sudeste com parábola doméstica e visada limpa para ENE.]
    ],
  )
]

// ============================================================
// SLIDE 53 — Planilha AMSAT-IARU
// ============================================================
#slide[
  == Planilha AMSAT-IARU: workflow

  #set text(size: 13pt)
  Estrutura em 21 abas; as que o experimentador preenche:

  #table(
    columns: (0.2fr, 0.8fr, 1.5fr),
    inset: 6pt,
    stroke: 0.35pt,
    align: horizon,
    table.header([*Nº*], [*Aba*], [*O que entra*]),
    [3], [*Orbit*], [LEO/HEO/GEO/Deep Space; ângulo de elevação mínimo; altitude],
    [4], [*Frequency*], [Frequências uplink e downlink ⇒ $lambda$ e FSPL],
    [5], [*Transmitters*], [$P_t$, perdas de linha, filtros, VSWR; saída: potência na antena],
    [6], [*Receivers*], [perdas pre-LNA, $T_a$, $T_"LNA"$, $G_"LNA"$; saída: $T_s$ e G/T],
    [7], [*Antenna Gain*], [Yagi / hélice / parabólica; dimensões ⇒ ganho dBi],
    [8], [*Pointing Losses*], [erro de apontamento $theta_1...theta_4$],
    [9], [*Polarization Loss*], [razão axial TX/RX + ângulo ⇒ perda de polarização],
    [10], [*Atmos. & Ionos.*], [tabelas por elevação/frequência],
    [11], [*Modulation-Demod*], [modulação + FEC + BER ⇒ $(E_b\/N_0)_"th"$],
    [12--13], [*Uplink/Downlink Budget*], [consolida $E_b\/N_0$ e $S\/N$],
    [14], [*System Performance*], [classificação verde/amarelo/vermelho],
  )

  #v(0.3em)
  #text(size: 12pt)[_Convenção de cores_: azul forte = entrada crítica; branco = entrada comum; preto em branco = constante/fórmula, não editar; amarelo = resultado intermediário; amarelo forte = resultado principal.]
]

// ============================================================
// SLIDE 54 — APRS via ISS
// ============================================================
#slide[
  == Exemplo: APRS via ISS (145,825 MHz, LEO)

  #set text(size: 13pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.7em,
    [
      *Geometria e parâmetros*:
      - ISS altitude $approx$ 400 km, $v approx$ 7,5 km/s.
      - Frequência 145,825 MHz, $lambda approx$ 2,06 m.
      - #link("https://www.ariss.org/current-status-of-iss-stations.html")[APRS ISS]: 145,825 MHz; alias `ARISS`/`APRSAT`, indicativo conforme status ARISS.
      - Janela útil AOS--LOS: $approx$ 4--10 min.

      *Setup do aluno*:
      - HT VHF 5 W FM (ex.: Baofeng UV-5R ou similar).
      - Yagi de 3 elementos de fita métrica, casada (SWR $approx 1$).
      - APRSdroid no celular + cabo de áudio.
      - Modulação AFSK Bell 202, AX.25 UI, APRS.
    ],
    [
      *Orçamento no TCA (zênite, $d$ = 400 km)*:
      #align(center)[
        #table(
          columns: (1.5fr, 0.7fr, 0.45fr),
          inset: 4pt,
          stroke: 0.4pt,
          align: (left, right, left),
          [EIRP], [+11,5], [dBW],
          [FSPL (400 km)], [-127,8], [dB],
          [Atmos + iono], [-1,8], [dB],
          [Apontamento], [-1,0], [dB],
          [Polarização], [-3,0], [dB],
          [$+ G_r$ (whip ISS)], [+2,1], [dBi],
          [$P_"sinal"$], [-120,0], [dBW],
        )
      ]

      $E_b\/N_0$ ideal no TCA: $approx$ 48 dB; a 10° de elevação ($d approx$ 1440 km): $approx$ 37 dB.
      Limiar AFSK/FM BER $10^(-5)$ = 23,2 dB.
      Margem prática: colisões, captura FM, polarização, fading, áudio e squelch.

      ACKs reais podem ficar bem abaixo do orçamento ideal.
    ],
  )
]

// ============================================================
// SLIDE 55 — QO-100: orçamento SHF e cadeia de RF
// ============================================================
#slide[
  == QO-100: orçamento em SHF e cadeia de RF

  #set text(size: 13pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.7em,
    [
      *Frequências e modos* (#link("https://amsat-dl.org/en/p4-a-nb-transponder-bandplan-and-operating-guidelines/")[QO-100 NB]):
      - *Uplink*: 2400,005--2400,490 MHz (banda S, $lambda approx 12.5$ cm).
      - *Downlink*: 10489,500--10490,000 MHz (banda X, $lambda approx 2.87$ cm).
      - Modos NB: SSB, CW, digitais estreitos; _wideband_ tem DATV.

      *Cadeia do TX (uplink 2,4 GHz)*:
      - Rádio HF/VHF SSB $=>$ *transverter* para 2,4 GHz ou SDR direto.
      - PA de 5--20 W em 13 cm.
      - *Antena*: hélice axial ou feed parabólico (RHCP).

      *Cadeia do RX (downlink 10 GHz)*:
      - *LNB* (_Low-Noise Block_) de TV por satélite: LO $approx$ 9750 MHz, saída em IF de 739,5 MHz.
      - SDR (RTL-SDR, Airspy) para demodular.
      - Parabólica de 60--90 cm (mesma das TVs).
    ],
    [
      *Orçamento típico (narrowband, downlink)*:
      #align(center)[
        #table(
          columns: (1.5fr, 0.7fr, 0.45fr),
          inset: 4pt,
          stroke: 0.4pt,
          align: (left, right, left),
          [EIRP do satélite], [+44], [dBW],
          [FSPL (40 000 km, 10,5 GHz)], [-205], [dB],
          [Atmos + chuva leve], [-0,5], [dB],
          [Apontamento], [-0,5], [dB],
          [Polarização (vertical)], [-0,2], [dB],
          [$+ G_r$ (parabólica 60 cm)], [+35], [dBi],
          [$P_"sinal"$], [-127], [dBW],
        )
      ]

      - $G\/T$ da estação terrena domina: LNB *no foco* da parabólica (zero perda pre-LNA), NF $approx$ 0,5 dB.
      - Margem em SSB: usar $C/N$ ou SNR em $B approx$ 2,4 kHz.
      - Mesma ordem de grandeza da ISS, mas *obtida com antena fixa e sem passagem*.

      #v(0.2em)
      #text(size: 11pt)[*Brasil*: elevação $approx$ 20° no NE, $approx$ 7° no Sudeste, $<$ 5° no Sul; em SP há relatos de operação com 60 cm, mas 75--90 cm é recomendado pela margem de chuva. Amazônia ocidental fica fora do footprint.]
    ],
  )
]

// ============================================================
// SLIDE 56 — ISS vs QO-100: tabela-resumo
// ============================================================
#slide[
  == ISS vs. QO-100: comparativo operacional

  #set text(size: 12pt)
  #table(
    columns: (0.6fr, 1.3fr, 1.3fr),
    inset: 3.5pt,
    stroke: 0.5pt,
    align: horizon,
    table.header([*Aspecto*], [*ISS (LEO)*], [*QO-100 (GEO)*]),
    [Altitude / distância], [$approx$ 400 km; $d$ varia 400--2000 km na passagem], [alt. 35 786 km; $d approx$ 40 mil km],
    [Disponibilidade], [Janelas de $approx$ 4--10 min, poucas por dia], [24/7 enquanto no footprint],
    [Footprint no Brasil], [Todo o território (passagens variam)], [Leste/centro-leste; NE $approx$ 20°, SE $approx$ 7°, S $<$ 5°],
    [Rastreio], [Software (ex. Gpredict), antena móvel ou apontar à mão], [Antena *fixa*, azimute/elevação constantes],
    [Doppler], [$plus.minus$ 3,6 kHz em VHF; $plus.minus$ 11 kHz em UHF], [Geométrico *zero*; deriva do LNB importa],
    [Frequências], [APRS 145,825 MHz; voz tip. 145,990 up / 437,800 down], [S 2,4 GHz (up) / X 10 GHz (down)],
    [Antenas típicas], [Yagi 3--5 el. de 2 m; chicote no 2 m], [Parabólica 60--90 cm + hélice/feed 2,4 GHz],
    [Modos], [FM voz/repetidora, AFSK/AX.25 (APRS), SSTV eventual], [SSB, CW, digitais, DATV],
    [Cadeia RX], [Rádio FM/SSB direto], [*LNB + SDR* (IF 740 MHz) obrigatório],
    [FSPL típica], [$approx$ 128 dB (2 m, zênite)], [$approx$ 204 dB (10 GHz)],
    [Ganho de antena], [$approx$ 7 dBi (Yagi 3 el.)], [$approx$ 35 dBi (parábola 60 cm)],
    [Orçamento ($P_"sinal"$)], [$approx$ -120 dBW (TCA)], [$approx$ -127 dBW (contínuo)],
  )

  #v(0.2em)
  #text(size: 11pt)[*Lição*: os mesmos princípios (Friis, G/T, margem) valem em ambos — só mudam os "tamanhos" das antenas e os extremos do espectro. FSPL cresce com $f$, mas ganho da parabólica cresce com $f^2$ (abertura fixa).]
]

// ============================================================
// SLIDE 57 — AX.25 como herdeiro do HDLC
// ============================================================
#slide[
  == AX.25: HDLC levado para o rádio

  #set text(size: 16pt)
  No Módulo 2, HDLC apareceu como a camada que transforma um fluxo síncrono de bits em *quadros delimitados*.

  #grid(
    columns: (1fr, 1fr),
    gutter: 0.8em,
    [
      *Ideias herdadas por AX.25:*
      - Flag `0x7E` (`01111110`) delimita o frame.
      - Transparência por *bit stuffing* após cinco `1`s.
      - FCS CRC-16 detecta erro no quadro.
      - Control field mantém a família I/S/U.
    ],
    [
      *O que muda no radioamadorismo:*
      - Endereços são *indicativos + SSID*.
      - Campo de digipeaters vira o caminho no ar.
      - APRS usa *UI*: sem conexão/ACK na camada AX.25.
      - Erro detectado não é corrigido: o frame some.
    ],
  )

  #v(0.3em)
  #text(size: 13pt)[Leitura didática: AX.25 é uma adaptação de HDLC/LAPB para enlaces de pacote em rádio; APRS usa apenas seu subconjunto de broadcast.]
]

// ============================================================
// SLIDE 58 — AX.25: formato do frame
// ============================================================
#slide[
  == AX.25: formato do frame UI

  #set text(size: 13pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.7em,
    [
      #table(
        columns: (0.9fr, 0.6fr, 1.3fr),
        inset: 5pt,
        stroke: 0.35pt,
        align: horizon,
        table.header([*Campo*], [*Bytes*], [*Função*]),
        [Flag], [1], [`0x7E` delimita início/fim],
        [Destino], [7], [indicativo + SSID destino],
        [Origem], [7], [indicativo + SSID origem],
        [Digipeaters], [0--56], [0 a 8 repetidores a percorrer],
        [Control], [1], [UI = `0x03`],
        [PID], [1], [`0xF0` = sem L3 (APRS direto)],
        [Info], [0--256], [payload (APRS, mensagem, etc.)],
        [FCS], [2], [CRC-16 estilo HDLC],
        [Flag], [1], [`0x7E` final],
      )
    ],
    [
      #set text(size: 14pt)
      *Pontos a notar:*
      - *UI* = _Unnumbered Information_: sem ACK AX.25; APRS messaging pode ter ACK na aplicação.
      - *SSID* (_Secondary Station Identifier_): 4 bits; permite 16 estações por indicativo (`-0` a `-15`).
      - Destino pode ser genérico (ex.: `APRS`); caminho real fica nos digipeaters.
      - FCS detecta erro ⇒ frame *descartado*. Sem FEC, um bit flip perde o frame.
    ],
  )
]

// ============================================================
// SLIDE 59 — AX.25 conectado e BBS
// ============================================================
#slide[
  == AX.25 conectado: mais que só APRS

  #set text(size: 16pt)
  APRS usa *só UI*. Mas AX.25 tem também:
  - *I-frames* (_Information_): numerados (N(S), N(R)), modo conectado.
  - *S-frames* (_Supervisory_): RR (_Receive Ready_), RNR (_Receive Not Ready_), REJ (_Reject_) — controle de fluxo e retransmissão.
  - *U-frames*: SABM (_Set Asynchronous Balanced Mode_), DISC, UA, UI.

  *Uso histórico clássico*: *BBSes de pacote* (PBBS, F6FBB, JNOS, NET/ROM, TheNET). Operador conecta a um BBS remoto, lê/deixa mensagens como em telnet.
  - Rodava em 1200 AFSK ou 9600 G3RUH.
  - Topologia ponto-a-ponto + _digipeating_ store-and-forward.
  - Ainda existem BBS ativos; Winlink é herdeiro moderno.

  #v(0.4em)
  #text(size: 14pt)[APRS redescobriu o AX.25 para broadcast: um único frame UI é lido por *todos* os ouvintes ao alcance, mais eficiente para difusão de posição do que o modelo conectado.]
]

// ============================================================
// SLIDE 60 — APRS: tipos de pacote
// ============================================================
#slide[
  == APRS: tipos de pacote

  #set text(size: 13pt)
  O primeiro byte do campo Info identifica o *Data Type Identifier*:

  #table(
    columns: (0.5fr, 1fr, 2fr),
    inset: 5pt,
    stroke: 0.35pt,
    align: horizon,
    table.header([*Byte*], [*Tipo*], [*Conteúdo*]),
    [`!`, `=`], [Posição sem/com messaging], [Lat, Long, símbolo, comentário],
    [`@`, `/`], [Posição com timestamp], [Lat/Long + data/hora],
    [`:`], [Mensagem], [destino (9 chars) + texto até 67 chars + ID em chave para ACK],
    [`>`], [Status], [texto livre descrevendo a estação],
    [`_`], [Weather (positionless)], [vento/temp/chuva/pressão em subcampos],
    [`;`], [Objeto], [estação "virtual" que pode ser criada por outra],
    [`)`], [Item], [similar a objeto, persistente],
    [`T`], [Telemetria], [até 5 canais analógicos + 8 digitais],
    [\`, \'], [Mic-E], [posição comprimida no destino AX.25],
    [\{], [User-defined], [experimentações],
  )
]

// ============================================================
// SLIDE 61 — APRS: símbolos e digipeating
// ============================================================
#slide[
  == APRS: símbolos e digipeating

  #set text(size: 14pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.7em,
    [
      *Símbolos*: 2 chars no pacote de posição.
      - Byte 1 = *tabela* (`/` primária, `\` alternada).
      - Byte 2 = *glifo* (carro, moto, antena, tenda, ...).
      - Sobrepõe letra/dígito para indicar operador.

      *SSID herdeiro* (sem posição): o *SSID do indicativo* mapeia para ícone:
      - `-9` carro, `-7` HT, `-11` balão, `-8` barco, etc.

      Caminho APRS fica nos campos digipeater/path, não no SSID destino.
    ],
    [
      *Digipeating (WIDEn-N)*:
      - Caminho escrito como `WIDE2-2`: 2 saltos pedidos, 2 restantes.
      - Cada digi que atende decrementa N: `WIDE2-2` → `WIDE2-1`; ao zerar, esgota.
      - Digis suprimem duplicatas por cerca de 30 s.
      - Caminho internet: via *IGates* para `APRS-IS` (rede de servidores APRS).

      *ISS como digipeater espacial*:
      - Caminho típico: `ARISS` ou `APRSAT` como alias via satélite.
      - Uma passagem da ISS cobre milhares de km no solo ⇒ cobertura continental em um frame.
    ],
  )
]

// ============================================================
// SLIDE 62 — Modulações AX.25/APRS
// ============================================================
#slide[
  == Modulações AX.25/APRS (recap)

  #set text(size: 16pt)
  *Bell 202 AFSK* (1200 bps, 2 m):
  - Tons: marca = 1200 Hz, espaço = 2200 Hz (áudio, passam via canal FM padrão).
  - AX.25 usa NRZI antes do AFSK; o preâmbulo usual são flags HDLC `0x7E` repetidas.
  - Entra no transceptor pelo microfone, sai do alto-falante ⇒ compatível com qualquer rádio FM.
  - Modulação coberta no Módulo 1.

  *G3RUH FSK* (9600 bps, VHF/UHF):
  - FSK direto sobre FM: "1" = desvio $+$, "0" = desvio $-$.
  - *Scrambler* LFSR ($x^(17) + x^(12) + 1$) antes da modulação.
  - *Problema*: no descrambler, um bit errado pode virar 3; FEC/interleaving ajudam.
  - Requer acesso à discriminadora (nem todo rádio comercial expõe).

  *BPSK / GMSK* (satélites modernos): ganho maior, exigem sincronismo mais fino.
  - *BPSK*: normalmente requer SSB ou SDR I/Q e cadeia de RF linear (mais caro que HT FM).
  - *GMSK*: envelope constante; aceita PA não-linear/FM, mas exige caminho de dados plano.
]

// ============================================================
// SLIDE 63 — Reed-Solomon: intuição visual
// ============================================================
#slide[
  == Reed-Solomon: intuição visual (ajuste por pontos)

  // Figura: quatro painéis lado a lado ilustrando a intuição de Reed-Solomon. (a) Dois pontos pretos ligados por uma reta. (b) Três pontos sobre uma parábola côncava para cima. (c) Parábola sobre-amostrada com sete pontos alinhados perfeitamente, representando um código com k=3 informação e n=7 total. (d) O mesmo gráfico (c), mas com dois dos pontos deslocados verticalmente (setas tracejadas). A parábola original (linha sólida) ainda passa por 5 dos 7 pontos; uma parábola "errada" tracejada passa por no máximo 4 pontos.
  #align(center)[
    #image("fig/rspoly_fig1.svg", width: 70%)
    #v(-0.6em)
    #text(size: 8pt)[Wolf, _An Introduction to Reed-Solomon Codes_, obtido de #link("http://pfister.ee.duke.edu/courses/ecen604/rspoly.pdf")[pfister.ee.duke.edu].]
  ]

  #set text(size: 16pt)
  *Ideia central:*
  - 2 pontos determinam uma reta.
  - 3 pontos determinam uma parábola.
  - $k$ pontos determinam um *polinômio de grau $k - 1$*.

  *Visão didática*: dados são os coeficientes $(f_0, f_1, ..., f_(k-1))$ de um polinômio $f(x)$. A *palavra-código* é o vetor das avaliações
  #align(center)[
    $ (f(x_0), f(x_1), ..., f(x_(n-1))) $
  ]
  em $n >= k$ pontos distintos.

  *Decoder*: se soubermos quais $k$ avaliações são confiáveis, elas reconstroem $f$ (Lagrange).
]

// ============================================================
// SLIDE 64 — RS: correção com erros
// ============================================================
#slide[
  == RS: correção de erros $t <= (n - k)/2$

  #set text(size: 16pt)
  *Teorema*: se $t$ pontos estão errados e $t <= (n-k)/2$, existe *exatamente um* polinômio de grau $< k$ que concorda com $n - t >= (n+k)/2$ avaliações.

  *Por quê?* Duas palavras-código distintas diferem em pelo menos $d_min = n-k+1$ pontos. Corrigir até $t$ erros exige $2t < d_min$.

  *Caso geral*: com $s$ apagamentos (_erasures_, posições sabidas corrompidas) e $t$ erros de posição desconhecida:
  #align(center)[
    $ s + 2 t <= n - k $
  ]

  *Para RS(255, 223)*: $n - k = 32$ paridade ⇒ corrige até $16$ bytes errados por bloco (ou 32 apagamentos).

  *Para RS(255, 239)* (IL2P com 16 paridade): corrige até *8 bytes* por bloco ($approx 3.1 %$).
]

// ============================================================
// SLIDE 65 — RS sobre GF(2^m)
// ============================================================
#slide[
  == RS sobre GF($2^m$): bytes como pontos

  #set text(size: 15pt)
  Convenção didática; implementações práticas, como IL2P, usam forma sistemática/cíclica equivalente:
  - Mensagem = coeficientes de $f(x)$, com grau $< k$.
  - Pontos de avaliação: $x_i = alpha^i$, para $i = 0, ..., n-1$.
  - Codeword = $(f(alpha^0), f(alpha^1), ..., f(alpha^(n-1)))$.
  - Em GF($2^8$), cada coeficiente e cada avaliação é um *byte*.
  - Comprimento máximo: $n <= 2^8 - 1 = 255$ (ponto zero é evitado).

  *Polinômio redutor* (define GF($2^8$)):
  #align(center)[
    $ x^8 + x^4 + x^3 + x^2 + 1 $
  ]
  (usado por IL2P, CD-ROM, QR Code...)

  *Por que corpo finito?*
  - Soma = XOR bit a bit; produto via tabelas ou LFSRs.
  - Operações exatas, sem erros de arredondamento.
  - Pré-requisitos cobertos no Módulo 2 (CRC, GF(2), polinômios geradores).
]

// ============================================================
// SLIDE 66 — Decodificação: síndromes e localizador
// ============================================================
#slide[
  == Decodificação RS: síndromes e localizador

  #set text(size: 14pt)
  Convenção: recebemos pontos corrompidos
  #align(center)[
    $ y_i = f(alpha^i) + e_i $
  ]
  e não sabemos onde $e_i != 0$. As *síndromes* são combinações dos $y_i$ que zerariam sem erro.

  Se há $t$ erros em posições $sigma(l)$, defina $X_l = alpha^(sigma(l))$:
  #align(center)[
    #text(size: 13pt)[$ S_j = sum_(l=1)^t e_l X_l^j, quad j=0, ..., n-k-1 $]
  ]
  Isto é uma soma de $t$ exponenciais em GF($2^8$): achar $X_l$ dá as posições; achar $e_l$ dá as correções.

  O *localizador* codifica as posições:
  #align(center)[
    $ Lambda(z) = product_(l=1)^t (1 - X_l z) $
  ]

  - *Berlekamp-Massey*: encontra $Lambda(z)$ a partir das síndromes.
  - *Chien*: testa potências de $alpha$; raízes $z = X_l^(-1)$ revelam as posições.
]

// ============================================================
// SLIDE 67 — Decodificação: avaliador e Forney
// ============================================================
#slide[
  == Decodificação RS: avaliador e Forney

  #set text(size: 15pt)
  Depois das posições, faltam as *magnitudes* dos erros.

  Série de síndromes e *avaliador*:
  #align(center)[
    #set text(size: 12pt)
    $ S(z) = sum_(j=0)^(n-k-1) S_j z^j $
    $ Omega(z) = [Lambda(z) S(z)] mod z^(n-k) $
  ]

  Para a posição $X_l = alpha^(sigma(l))$, a raiz de $Lambda$ é $X_l^(-1)$.

  *Fórmula de Forney*:
  #align(center)[
    $ e_l = - X_l dot Omega(X_l^(-1)) / Lambda'(X_l^(-1)) $
  ]

  $Lambda'(z)$ é a derivada formal em GF($2^8$). Corrigir é subtrair $e_l$ de $y_(sigma(l))$.

  *Passos do decodificador*:
  #align(center)[
    Síndromes $S_j$ $=>$ Berlekamp-Massey $=>$ Chien $=>$ Forney $=>$ correção
  ]
]

// ============================================================
// SLIDE 68 — IL2P: alternativa moderna ao AX.25
// ============================================================
#slide[
  == IL2P: alternativa moderna ao AX.25

  #set text(size: 14pt)
  *IL2P* = _Improved Layer 2 Protocol_, Nino Carrillo (KK4HEJ), 2019.

  Motivação:
  - AX.25 tradicional: *1 bit errado ⇒ frame descartado*. Sem FEC.
  - G3RUH tem _bit-error amplification_ no scrambler.
  - Herança HDLC do AX.25 (flag `0x7E`, bit stuffing e FCS final) não ajuda quando o canal já tem erros em rajada.

  *Decisões de projeto*:
  + *RS(255, k)* sobre GF($2^8$) com o polinômio $x^8 + x^4 + x^3 + x^2 + 1$.
  + Paridade ajustável: 2, 4, 6, 8 ou *16* bytes (16 = padrão, corrige 8 erros por bloco).
  + Na prática usa uma forma sistemática/cíclica equivalente: payload intacto + bytes de paridade.
  + Abandona a lógica HDLC: *sem flag `0x7E` e sem bit stuffing*; sync word fixo de 3 bytes.
  + FEC corrige/detecta muitos erros; miscorreção ainda é possível.
  + *Payloads longos*: divididos em múltiplos blocos RS(255, 239); intercalação depende do perfil.
  + *TNC híbrido*: mesma interface KISS para clientes APRS e softwares de packet. *Direwolf* implementa ambos.

  *ISS ainda não suporta* IL2P — mas Direwolf + IL2P já opera em digipeaters modernos.
]

// ============================================================
// SLIDE 69 — IL2P: coding gain
// ============================================================
#slide[
  == IL2P: ganho de codificação no orçamento

  #set text(size: 15pt)
  *Por que FEC vale a pena no radioamadorismo?*

  Um código RS(255, 239) com 16 bytes de paridade custa $approx 6 %$ de taxa, mas *corrige 8 bytes* por bloco.

  Em termos de $E_b\/N_0$ para BER final $10^(-5)$:
  - AX.25 sem FEC: Bell 202 AFSK precisa $E_b\/N_0 approx$ 23 dB.
  - IL2P com RS: tolera BER pré-RS maior. Ganho prático: *1--3 dB*.

  *Tradução em link budget*:
  - +3 dB $equiv$ metade da potência TX $equiv$ $times sqrt(2) approx$ 1,4 de alcance.
  - Para um QSO com satélite a 1000 km marginal, $+3$ dB faz a diferença entre *decodificar* ou *não*.

  *Perspectiva didática*: FEC é a versão "em software" do que no mundo RF-analógico se obtém com LNA de baixo ruído, antena de maior ganho, ou mais potência de TX. Cada um custa alguma coisa (dinheiro, tamanho, bateria); FEC custa um pouco de overhead + CPU.
]

// ============================================================
// SLIDE 70 — Síntese
// ============================================================
#slide[
  == Síntese do módulo

  #set text(size: 15pt)
  - *Radioamadorismo*: espectro protegido para aprender RF legalmente, com três classes no Brasil e janelas SAT explícitas em 2 m e 70 cm.
  - *Antenas*: radiação vem de campos retardados; o modelo $R_r + j X$ resume a impedância vista pelo gerador; $R_r$ é a fração da potência que vira onda distante.
  - *Antenas curtas ou longas*: exigem casamento, que tem *custo* em eficiência e banda — os elementos de casamento têm $Q$ finito.
  - *Simulação*: NEC2 (MoM) para fios finos, OpenEMS (FDTD) para volumes. Ambos resolvem Maxwell de verdade, sem supor RLC.
  - *Yagi-Uda*: refletor indutivo + diretor capacitivo produzem endfire; casamento via dipolo dobrado, gamma ou hairpin.
  - *NanoVNA*: calibração com cabo + S11/S21 conectam medida com simulação; separa ressonância de casamento.
  - *Link budget*: Friis + G/T + $E_b\/N_0$ fecha quando margem $>= 6$ dB. Planilha AMSAT organiza tudo.
  - *ISS (LEO) vs QO-100 (GEO)*: mesmos princípios, extremos opostos — rastreio+Doppler+VHF de um lado, antena fixa+SHF+parabólica do outro.
  - *APRS/AX.25*: UI frames de broadcast; ISS como digi espacial em 145,825 MHz.
  - *Reed-Solomon e IL2P*: polinômio por pontos em GF($2^8$); ganho prático de 1--3 dB paga overhead.
]
