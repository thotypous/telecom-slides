#import "@preview/polylux:0.4.0": *
#import "@preview/fletcher:0.5.7" as fletcher: node, edge
#import "@preview/cetz:0.3.4": canvas
#import "@preview/cetz-plot:0.1.1": plot

// Make the paper dimensions fit for a presentation and the text larger
#set page(paper: "presentation-16-9")
#set text(font: "Inria Sans", size: 25pt, lang: "pt", region: "br")

#slide[
  #align(horizon + center)[
    = Tecnologia de Comunicação

    Módulo 1 -- Conceitos básicos & modulação digital

    Prof. Paulo Matias
  ]
]

#slide[
  == Apresentação da disciplina

  - Cinco _práticas_ acompanhadas dos conceitos relacionados:
    + Modem V.21
    + Interface E1
    + Interface Ethernet
    + Antena Yagi-Uda / comunicação via satélite
    + IEEE 802.11 (Wi-Fi)
  - Cinco _mini testes_ antes das práticas
  - Seminário com apresentação de experimento próprio
]

#slide[
  == Avaliação

  - 50% -- práticas (em grupo)
  - 20% -- quatro melhores mini testes (individual)
  - 30% -- seminário (em grupo)
]

#slide[
  == Objetivo da disciplina

  Transmitir informação por um canal e recebê-la do outro lado.

  #v(-0.5em)
  #fletcher.diagram(
    spacing: 1em,
    node-stroke: 1pt,
    edge-stroke: 1pt,
    node((0,0), [0110...010]),
    edge("-|>"),
    node((1,0), [modulador], shape: fletcher.shapes.pill),
    edge("-|>"),
    node((2,0), [canal], shape: fletcher.shapes.circle),
    edge("-|>"),
    node((3,0), [demodulador], shape: fletcher.shapes.pill),
    edge("-|>"),
    node((4,0), [0110...110]),
  )
  
  - O canal adiciona ruído, interferência, distorções ao sinal.

  - O demodulador não está perfeitamente sincronizado com o modulador.

  - Em algumas tecnologias, há mais de um usuário compartilhando o mesmo canal.
]

#slide[
  == Ruído gaussiano branco aditivo (AWGN)
  #v(1em)
  
  $ r_t = s_t + w_t $
  
  onde $w_t$ é uma variável aleatória regida pela distribuição $1/(sigma sqrt(2 pi)) e^(-x^2/(2 sigma^2))$

  #v(1em)
  É o modelo de ruído mais utilizado. Por quê?
  
  - Ruído térmico
  - #link("https://en.wikipedia.org/wiki/Lindeberg%27s_condition")[Teorema do limite central de Lindeberg]

]

#slide[
  == Densidade espectral do AWGN

  #align(center)[
  ```py
  plt.psd(5*np.random.randn(10000000))
  ```
  #image("psd1.svg", width: 45%)
  ]

  Com $sigma=5$, temos $N_0=sigma^2=25 approx 10^(14/10)$
]

#slide[
  Alguns autores distribuem $N_0/2$ para $f<0$ e $N_0/2$ para $f>=0$:

  #align(center)[
  ```py
  plt.psd(5*np.random.randn(10000000), sides='twosided')
  ```
  #image("psd2.svg", width: 45%)
  ]

  Note que $N_0/2=12.5 approx 10^(11/10)$
]

#slide[
  == Demonstração de AWGN

  $ s(t) = sin(2 pi f_0 t) quad "e" quad r(t) = s(t) + w(t) $

  #align(center)[
    #image("awgn_demo.svg", width: 88%)
  ]

  #grid(
    columns: (1.2fr, 1fr),
    gutter: 1.2em,
    [
      #text(size: 12pt)[
        ```py
        t = np.linspace(0, 1.2, 700)
        s = np.sin(2*pi*5*t)
        r = s + np.random.normal(0, sigma, size=t.shape)
        ```
      ]
    ],
    [
      #text(size: 16pt)[Em qual valor de $sigma$ a frequência ainda é identificável visualmente?]
    ],
  )
]

#slide[
  == Capacidade teórica de um canal AWGN

  Teorema de Shannon--Hartley:

  $ C = B log_2(1 + S/N) $

  - $C$: capacidade (bit/s)
  - $B$: banda (Hz)
  - $S$: potência do sinal (W)
  - $N$: potência do ruído (W)

  #text(size: 14pt)[Para uma prova do teorema, veja Wozencraft & Jacobs, _Principles of Communication Engineering_, 1966, pp. 323--342.]
]

#slide[
  Mas $N$ depende de $B$, por exemplo:
  
  #canvas(length: 1cm, {
    plot.plot(size: (24, 4),
      x-label: [#v(0.5em)Frequência],
      y-label: [PSD],
      x-tick-step: none,
      y-tick-step: none,
      x-ticks: ((-5, $f_1$), (-1, $f_2$), (1, $f_3$), (5, $f_4$)),
      y-ticks: ((1, $N_0$), (5, $S_0$)),
      y-min: 0,
      y-max: 5,
      {
        plot.add(
          fill: true,
          style: (stroke: black, fill: rgb(200, 0, 0, 75)),
          domain: (-10, 10), _ => 1)
        plot.add(
          fill: true,
          style: (stroke: black, fill: rgb(0, 0, 200, 75)),
          domain: (-1, 1), _ => 5)
      })
  })

  #text(size: 22pt)[
    Se $B=f_3-f_2$, então $S=S_0 dot (f_3-f_2)$ e $N=N_0 dot (f_3-f_2)$.
    
    Se $B=f_4-f_1$, continuamos com $S=S_0 dot (f_3-f_2)$, \ mas $N=N_0 dot (f_4-f_1)$.
  ]
]

#slide[
  E se pudermos escolher $B$ tão grande quanto quisermos?

  Lembrando que $C = B log_2(1 + S/N) = log_2(1 + S/(B dot N_0))^B $,

  $ lim_(B->infinity) log_2(1 + S/(B dot N_0))^B = log_2 e^(S/N_0) = S/N_0 log_2 e approx 1.44 S/N_0$

  #v(1em)
  A expressão acima permite calcular a capacidade quando o fator limitante é a potência (e consequentemente o gasto de energia) para transmitir o sinal.
  
]

#slide[
  Ainda na condição de $B->infinity$, e se quisermos comparar $C$, que é a taxa máxima teórica, com a taxa real $f_b$ do transmissor?

  
  $ C/f_b = S/f_b 1/N_0 log_2 e $

  A grandeza $S/f_b$ é bastante utilizada e recebe o nome $E_b$. Note que ela tem dimensão de joules por bit. Trata-se da energia empregada para transmitir um único bit. Temos assim:

  $ C/f_b = E_b/N_0 log_2 e $
]

#slide[
  #align(center)[Como $f_b <= C$,]
  
  $ 1 <= C/f_b $
  
  $ E_b/N_0 log_2 e >= 1 $

  $ E_b/N_0 >= 1/(log_2 e) approx 0.693 approx -1.59 "dB" $
]

#slide[
  - Gráficos de BER (taxa de bits errados) _vs_ $E_b/N_0$ são bastante usados para avaliar o desempenho de sistemas de telecomunicação.

  - Para chegar perto do limite teórico de $-1.59 "dB"$, além de banda muito superior à taxa de transmissão, é necessário usar códigos de correção de erro.
]

#slide[
  #align(center)[#image("coding_gain_concept.svg", width: 94%)]
]

#slide[
  #align(center)[
    #image("jpl-shannon.svg", width: 72%)
    #v(-1em)
    #text(size: 10pt)[_Approaching The Shannon Limit at JPL: 1969--2008_, obtido de leecenter.caltech.edu.]
  ]
]

#slide[
  == Teoria de linhas de transmissão
  #align(center)[
    #image("Transmission_line_element.svg", width: 73%)
    #v(-1em)
    #text(size: 10pt)[Adaptado de _Microwave and RF Design II_ -- Transmission Line Theory, disponível em #link("https://eng.libretexts.org/Bookshelves/Electrical_Engineering/Electronics/Microwave_and_RF_Design_II_-_Transmission_Lines_(Steer)/02%3A_Transmission_Lines/2.02%3A_Transmission_Line_Theory")[eng.libretexts.org].]
  ]

  $ (partial v(z,t))/(partial z) = - R i(z,t) - L (partial i(z,t))/(partial t) $

  $ (partial i(z,t))/(partial z) = - G v(z,t) - C (partial v(z,t))/(partial t) $
]

#slide[
  Substituindo soluções do tipo $e^(j omega t)$, temos:

  #v(2em)
  $ (d V(z))/(d z) = -(R + j omega L) I(z) $
  $ (d I(z))/(d z) = -(G + j omega C) V(z) $
]

#slide[
  Substituindo uma equação na outra, e vice-versa, temos:

  $ (d^2V(z))/(d z^2) - gamma^2 V(z) = 0 $

  $ (d^2I(z))/(d z^2) - gamma^2 I(z) = 0 $

  onde:

  $ gamma = sqrt((R+j omega L)(G + j omega C)) $
]

#slide[
  Convém separar $gamma$ em parte real ($alpha$) e parte imaginária ($beta$).
  
  - $alpha = frak("Re"){gamma}$ é a constante de atenuação

  - $beta = frak("Im"){gamma}$ é a constante de fase

  Em uma *linha de transmissão ideal*, $R=G=0$, então temos 
  $ gamma = sqrt(j^2 omega^2 L C) = j omega sqrt(L C) $
  
  Ou seja, $alpha=0$, que significa que a linha não atenua o sinal, \ e $beta=omega sqrt(L C)$. A velocidade de fase é $v_p = omega / beta$, que no caso da linha ideal dá $1/sqrt(L C)$ e é igual à velocidade de grupo.
]

#slide[
  Em uma *linha de transmissão não ideal*, com $R!=0$ ou $G!=0$, temos atenuação e, além disso, a velocidade de fase é diferente da velocidade de grupo, o que causa dispersão do sinal conforme este se propaga pela linha:

  #fletcher.diagram(
    spacing: 4em,
    edge-stroke: 2pt,
    node((0,0), [#image("dispersion1.png", width: 10.5cm)]),
    edge("-|>"),
    node((1,0), [#image("dispersion2.png", width: 10.5cm)]),
  ) \
  #text(size: 10pt)[Adaptado de Bertolotti, _Telegrapher's Equation_, disponível em #link("https://en.wikipedia.org/wiki/Telegrapher%27s_equations#/media/File:Telegrapher_equation.gif")[en.wikipedia.org].]
]

#slide[
  A atenuação cresce com a frequência, efetivamente limitando a banda que pode passar pelo cabo.
  
  Os valores de $R$, $L$, $G$, $C$ podem variar com $omega$. Por exemplo, $R$ tende a aumentar com a frequência devido ao efeito pelicular (_skin effect_), fazendo com que a atenuação cresça com a frequência ainda mais rápido do que cresceria se $R$ fosse constante.
]

#slide[
  == Atenuação, dispersão e taxa de dados

  #align(center)[
    #image("eye_pam_lengths.svg", width: 80%)
  ]

  #set text(size: 20pt)
  - Maior comprimento de cabo: menor abertura do olho no instante de decisão.
  - Olho mais aberto: mais margem contra ruído e erro de temporização.
  - Olho mais fechado: menor taxa possível ou necessidade de equalização.
]

#slide[
  #align(center)[
    Cabo de telefone 24 AWG isolado com polietileno
    #v(1em)
    #image("PE-89-1.jpg", width: 40%)
    #v(-1em)
    #text(size: 10pt)[Imagem de #link("https://www.caledonian-cables.co.uk/products/telephone-cable/pe-89.shtml")[caledonian-cables.co.uk].]
  ]
]

#slide[
  #align(center)[
    Atenuação de um cabo de telefone 24 AWG isolado com polietileno
    #image("attenuation.svg", width: 85%)
    #v(-1.5em)
    #text(size: 10pt)[Com base em medidas de $R$, $L$, $G$, $C$ de Reeve, _Subscriber Loop Signaling and Transmission Handbook_, 1995, p. 558.]
  ]
]

#slide[
  == Uma breve história da telefonia
  #place(left+horizon)[
    1870s: primeiras \ centrais telefônicas
  ]
  #place(right+horizon)[
    #image("Swbd_333_sm.gif", width: 41%)
    #v(-1em)
    #text(size: 10pt)[Hearfield, _A manual telephone exchange: CBS2_, obtido de #link("https://www.johnhearfield.com/Telephone/CBS2.htm")[johnhearfield.com].]
  ]
]

#slide[
  #align(center+horizon)[
    #image("Subs_ln_cct.gif", width: 98%)
    #v(-1em)
    #text(size: 10pt)[Hearfield, _A manual telephone exchange: CBS2_, obtido de #link("https://www.johnhearfield.com/Telephone/CBS2.htm")[johnhearfield.com].]
  ]
]

#slide[
  #align(center+horizon)[
    #image("Cord_cct.gif", width: 95%)
    #v(-1em)
    #text(size: 10pt)[Hearfield, _A manual telephone exchange: CBS2_, obtido de #link("https://www.johnhearfield.com/Telephone/CBS2.htm")[johnhearfield.com].]
  ]
]

#slide[
  #align(center+horizon)[
    _L-carrier system_ (FDM): 1930s -- 1970s
    
    #image("FDM_drawings_1.jpg", width: 90%)
    #v(-1em)
    #text(size: 10pt)[Adaptado de Steveo1544, _FDM drawings_, obtido de #link("https://en.wikipedia.org/wiki/File:FDM_drawings_1.jpg")[en.wikipedia.org].]
  ]
]

#slide[
  #align(center+horizon)[
    _T-carrier system_ (TDM): 1960s -- hoje
    
    #image("tdm.svg", width: 95%)
    #v(-0.5em)
    #text(size: 10pt)[Tibbs, _Pocket Guide to The world of E1_, 2002, obtido de #link("https://web.archive.org/web/20240429125245/https://web.fe.up.pt/~mleitao/STEL/Tecnico/E1_ACTERNA.pdf")[web.fe.up.pt].]
  ]
]

#slide[
  - Componentes como capacitores e transformadores de isolação limitam a resposta da linha próximo de DC.
  
  - O FDM utilizava uma separação de 4 kHz entre os canais.

  - O TDM usa uma taxa de amostragem de 8 kHz, limitando a banda em 4 kHz de acordo com Nyquist.

  - Para ligações telefônicas, geralmente considera-se como banda utilizável a faixa em torno de 300 Hz a 3400 Hz.
  
    (Apesar do cabo da casa até a central geralmente suportar bem mais banda --- por isso que o ADSL é possível.)
]


#slide[
  == Pulse Amplitude Modulation (PAM)

  #align(center)[
    #image("pam.svg", width: 46%)
    #v(-1em)
    #text(size: 10pt)[Oppenheim & Verghese, _6.011 Introduction to communication control and signal processing_, 2010, obtido de #link("https://ocw.mit.edu/courses/6-011-introduction-to-communication-control-and-signal-processing-spring-2010/d2df3fc906190f978ad666c9c63cdc5d_MIT6_011S10_chap12.pdf")[ocw.mit.edu].]
  ]
  
  $ x(t) = sum_n a[n]p(t-n T) $
]

#slide[
  #align(center)[
    #image("pam_tx_rx.svg", width: 100%)
    #v(-0.5em)
    #text(size: 10pt)[Oppenheim & Verghese, _6.011 Introduction to communication control and signal processing_, 2010, obtido de #link("https://ocw.mit.edu/courses/6-011-introduction-to-communication-control-and-signal-processing-spring-2010/d2df3fc906190f978ad666c9c63cdc5d_MIT6_011S10_chap12.pdf")[ocw.mit.edu].]
  ]
  #v(1em)
  
  $ X(j omega) = sum_n a[n] thick P(j omega) e^(-j omega n T) = A(e^(j Omega))|_(Omega=omega T) P(j omega) $

  $ R(j omega) = H(j omega) X(j omega) $

  $ B(j omega) = F(j omega) H(j omega) X(j omega) $
]

#slide[
    $ X(j omega) = A(e^(j Omega))|_(Omega=omega T) P(j omega) $
  
    $ B(j omega) = F(j omega) H(j omega) X(j omega) $
  
  - Precisamos conhecer $A(e^(j Omega))$ em todo o intervalo $|Omega|<=pi$ \ $ <=> |omega|<=pi/T$ para conseguir reconstruir $a[n]$.

  - Precisamos que $P(j omega)!=0$, $H(j omega)!=0$ e $F(j omega)!=0$ em $|omega|<=pi/T$ para conseguir obter $A(e^(j Omega))$ em todo o intervalo $|Omega|<=pi$ a partir de $B(j omega)$.
]

#slide[
  #align(center)[
    #image("pam_tx_rx.svg", width: 100%)
    #v(-0.5em)
    #text(size: 10pt)[Oppenheim & Verghese, _6.011 Introduction to communication control and signal processing_, 2010, obtido de #link("https://ocw.mit.edu/courses/6-011-introduction-to-communication-control-and-signal-processing-spring-2010/d2df3fc906190f978ad666c9c63cdc5d_MIT6_011S10_chap12.pdf")[ocw.mit.edu].]
  
    $ b(t) = sum_n a[n] g(t-n T) $

    onde $g(t) = f(t) * h(t) * p(t)$
  ]

  Note que se $g(0)=c$ e $g(n T)=0$ para $n!=0$, então $b(n T) = c dot a[n]$, ou seja, não há ISI --- pulsos emitidos em diferentes instantes de tempo não interferem uns com os outros no sinal $b(t)$.
]

#slide[
  - Uma função que satisfaz essa condição é $g(t)=sin(pi/T t)/(pi/T t)$. Nesse caso,  $G(j omega)$ é constante no intervalo $|omega|<=pi/T$ e zero fora dele.
  
  - Na prática, é difícil trabalhar com pulsos no formato sinc porque eles decaem devagar. Uma alternativa comum é utilizar _raised cosine pulses_: $g(t)=sin(pi/T t)/(pi/T t) cos(beta pi/T t)/(1-(2 beta t/T)^2)$. Nesse caso, $G(j omega)$ fica contido num intervalo mais largo $|omega|<=pi/T (1+beta)$.
  
  - Deve-se projetar o pulso $p(t)$ e o filtro $f(t)$ para "anular" o efeito do canal $h(t)$, obtendo-se um $g(t)$ como acima. Se $H(j omega)=1$, adota-se $P(j omega)=F(j omega)=sqrt(G(j omega))$.
]

#slide[
  #align(center)[
    #image("pulse_compare.svg", width: 92%)
  ]
]

#slide[
  - Sinc: menor banda ideal, mas maior sensibilidade a erro de temporização.
  - Raised cosine com $beta$ maior: olho mais robusto, porém com maior excesso de banda.
  - Na prática, escolhemos um compromisso entre ocupação espectral e robustez à dessincronização.
]

#slide[
  A modulação PAM produz sinais em banda base, ou seja, de DC até uma certa frequência de corte.

  #v(1em)
  A seguir, veremos modulações que produzem um sinal em banda passante, ou seja, de uma frequência mínima até uma frequência máxima.
]

#slide[
  == Frequency Shift Keying (FSK)

  #v(1em)
  $ s(t) = sum_n a[n] p(t-n T)cos((omega_c + Delta_n)t+theta_c) $

  - Transmite-se os dados variando $Delta_n$.

  - Em tese, seria possível variar também $a[n]$, mas não é usual.

  - Se em vez disso o cosseno tiver uma amplitude constante $A$, \ FSK produz um sinal com envelope constante, que facilita o uso de amplificadores de alta eficiência.
]

#slide[
  #place(left+horizon)[
    Duas maneiras de modular FSK:

    - *Osciladores chaveados*: \ Alterna-se entre a saída de \ $M$ osciladores do tipo \ $A cos((omega_c + Delta_n)t)$.

    - *Fase contínua*: \ Produz-se $A cos(phi)$ como saída, \ incrementando $phi$ de $(omega_c + Delta_n) Delta t$ \ a cada intervalo de tempo $Delta t$.
  ]
   
  #place(right+horizon)[
    #image("cont_osc.svg", width: 45%)
    #v(-1em)
    #text(size: 10pt)[Tretter, _Additional Experiments for Communication System Design\  Using DSP Algorithms_, obtido de #link("https://user.eng.umd.edu/~tretter/commlab/c6713slides/AdditionalExperiments.pdf")[user.eng.umd.edu].]
  ]
]

#slide[
  O modulador de fase contínua pode, ainda, ser generalizado como:

  $ s(t) = A cos(omega_c t + phi.alt(t)) $

  #v(1em)
  onde

  #v(-2.8em)
  $ phi.alt(t) = omega_d integral_(-infinity)^t m(tau) d tau med, quad quad m(t) = sum_n a[n] p(t-n T) $

  Se usarmos um pulso limitador de banda, conseguimos uma maior redução da largura de banda do sinal.
  
  Mas, ao contrário do formalismo que desenvolvemos para o PAM, aqui $p$ atua de forma não linear sobre $s(t)$.
]

#slide[
  == Phase Shift Keying (PSK)

  #v(1em)
  $ s(t) = sum_n a med p(t-n T)cos(omega_c t + theta_n) $

  - Varia-se $theta_n$ para transmitir os dados.
  
  - Escolhe-se $theta_n=2 pi b_n/M+theta_0$ para utilizar $M$ opções de ângulos igualmente espaçados.
]

#slide[
  Uma formulação alternativa é:

  $ s(t) = sum_n frak("Re"){a med e^(j theta_n) p(t-n T)e^(j omega_c t)} $

  ou:

  $ s(t) = I(t) cos(omega_c t) - Q(t) sin(omega_c t) $

  onde $I(t) = sum_n a_i [n] p(t-n T)$ e $Q(t) = sum_n a_q [n] p(t-n T)$
  
  onde $a_i [n] = a cos(theta_n)$ e $a_q [n] = a sin(theta_n)$
]

#slide[
  Abaixo, visualizamos no plano IQ um caso especial de PSK com \ $M=4$, conhecido como QPSK.

  #align(center)[
    #image("qpsk.svg", width: 46%)
    #v(-1em)
    #text(size: 10pt)[Oppenheim & Verghese, _6.011 Introduction to communication control and signal processing_, 2010, obtido de #link("https://ocw.mit.edu/courses/6-011-introduction-to-communication-control-and-signal-processing-spring-2010/d2df3fc906190f978ad666c9c63cdc5d_MIT6_011S10_chap12.pdf")[ocw.mit.edu].]
  ]
]

#slide[
  == Quadrature Amplitude Modulation (QAM)

  #align(center)[
    #image("qam.svg", width: 42%)
    #v(-1em)
    #text(size: 10pt)[Oppenheim & Verghese, _6.011 Introduction to communication control and signal processing_, 2010, obtido de #link("https://ocw.mit.edu/courses/6-011-introduction-to-communication-control-and-signal-processing-spring-2010/d2df3fc906190f978ad666c9c63cdc5d_MIT6_011S10_chap12.pdf")[ocw.mit.edu].]
  ]
]

#slide[
  #align(center)[
    #image("constellation_compare.svg", width: 96%)
  ]
  #text(size: 22pt)[
    - Quanto mais densa a constelação, maior a eficiência espectral, mas maior o $E_b/N_0$ necessário para manter a BER baixa.
    - BPSK e QPSK são mais robustas; 16-QAM e 64-QAM transmitem mais bits por símbolo, porém com menor distância mínima entre pontos.
  ]
]

#slide[
  == Offset QPSK (OQPSK)

  QPSK com deslocamento de meio período entre as componentes.

  #align(center)[
    #image("OQPSK_timing_diagram.png", width: 70%)
    #v(-1em)
    #text(size: 10pt)[Splash, _Timing diagram for offset-QPSK_, obtido de #link("https://commons.wikimedia.org/wiki/File:OQPSK_timing_diagram.png")[commons.wikimedia.org].]
  ]
]

#slide[
  OQPSK limita as mudanças de fase a 90°, em vez dos 180° do QPSK.

  #align(center)[
    #image("Oqpsk_phase_plot.svg", width: 47%)
    #v(-1em)
    #text(size: 10pt)[Alejo2083, _OQPSK phase plot_, obtido de #link("https://commons.wikimedia.org/wiki/File:Oqpsk_phase_plot.svg")[commons.wikimedia.org].]
  ]
]

#slide[
  == Demodulação IQ

  Relembrando algumas identidades trigonométricas:

  $ sin(a)cos(a) = 1/2 (sin(a)cos(a)+sin(a)cos(a)) = 1/2 sin(2a) $

  $ cos^2(a) = 1/2 (cos^2(a) + 1-sin^2(a)) = 1/2 (1 + cos(2a)) $
  
  $ sin^2(a) = 1/2 (sin^2(a) + 1-cos^2(a)) = 1/2 (1 - cos(2a)) $
]

#slide[
  $ s(t) = I(t) cos(omega_c t) - Q(t) sin(omega_c t) $
  
  $ r_i (t) = s(t) cos(omega_t) = I(t) cos^2(omega_c t) - Q(t) sin(omega_c t) cos(omega_c t) \
    = 1/2 I(t) + 1/2 I(t) cos(2 omega_c t) - 1/2 Q(t) sin(2 omega_c t) $

  $ r_q (t) = - s(t) sin(omega_t) = - I(t) cos(omega_c t) sin(omega_c t) + Q(t) sin^2(omega_c t) \
    = - 1/2 I(t) sin(2 omega_c t) + 1/2 Q(t) - 1/2 Q(t) cos(2 omega_c t) $

  Aplica-se, então, um filtro passa-baixas para eliminar os termos que oscilam ao redor de $2omega_c$.
]

#slide[
  #align(center)[
    #image("iq_demod.svg", width: 80%)
    #v(-1em)
    #text(size: 10pt)[Adaptado de Oppenheim & Verghese, _6.011 Introduction to communication control and signal processing_, 2010, obtido de #link("https://ocw.mit.edu/courses/6-011-introduction-to-communication-control-and-signal-processing-spring-2010/d2df3fc906190f978ad666c9c63cdc5d_MIT6_011S10_chap12.pdf")[ocw.mit.edu].]
  ]
]

#slide[
  == Erro no oscilador local

  #align(center)[
    #image("carrier_offset_demo.svg", width: 92%)
  ]

  #set text(size: 18pt)
  - Erro de fase $Delta phi$: a constelação inteira sofre uma rotação fixa.
  - Erro de frequência $Delta f$: a constelação continua girando com o tempo, \ exigindo _carrier recovery_.
  - Esse problema aparece em praticamente todas as práticas, do V.21 ao 802.11.
]

#slide[
  == Demodulação FSK (usando _tone filters_)

  #align(center)[
    #image("tonefilter.svg", width: 99%)
    #v(-1em)
    #text(size: 10pt)[Tretter, _Additional Experiments for Communication System Design  Using DSP Algorithms_, obtido de #link("https://user.eng.umd.edu/~tretter/commlab/c6713slides/AdditionalExperiments.pdf")[user.eng.umd.edu].]
  ]

  $ G_k (z) = sum_(n=0)^(L-1) r^n e^(j Lambda_k n t_s) z^(-n) = (1 - r^L e^(j Lambda_k L t_s) z^(-L))/(1 - r e^(j Lambda_k t_s) z^(-1)), quad r = 1 - epsilon.alt $
]

#slide[
  == Visão do FSK no plano IQ

  #align(center)[
    #image("fsk_iq.svg", width: 38%)
    #v(-1em)
    #text(size: 10pt)[Šabanović, _Low-SNR Operation of FSK Demodulators_, obtido de #link("https://repository.tudelft.nl/islandora/object/uuid%3A98a156a1-3899-4d7c-86cd-dc223b73ab40")[repository.tudelft.nl].]
  ]

  $ h = (2 omega_d)/omega_b = (Delta omega)/omega_b med, quad quad phi.alt(t) = tan_c^(-1)(Q(t)/I(t)) $
]

#slide[
  == Demodulação FSK (a partir dos sinais IQ)

  $ d/(d t) [tan_c^(-1)(Q(t)/I(t))] = (I(t)Q'(t)-I'(t)Q(t))/(I^2(t)+Q^2(t)) $

  #v(-0.5em)
  #align(center)[
    #image("fsk_demod_arctan_deriv.svg", width: 56%)
    #v(-1em)
    #text(size: 10pt)[Šabanović, _Low-SNR Operation of FSK Demodulators_, obtido de #link("https://repository.tudelft.nl/islandora/object/uuid%3A98a156a1-3899-4d7c-86cd-dc223b73ab40")[repository.tudelft.nl].]
  ]
]

#slide[
  == Comparação de métodos de demodulação FSK

  #table(
    columns: (1.2fr, 1.5fr, 1.8fr),
    inset: 7pt,
    stroke: 0.5pt,
    align: horizon,
    table.header(
      [*Método*], [*Vantagens*], [*Desvantagens*]
    ),
    [Filtros de tom],[Simples, funciona sem IQ],[Necessita ajuste da largura dos filtros],
    [Derivada da fase (IQ)],[Compacto, funciona com qualquer $h$],[Precisa de demodulador IQ prévio e é sensível a ruído na divisão],
  )

  #v(0.5em)
  - Na prática P1, usaremos filtros de tom.
]

#slide[
  == Minimum Shift Keying (MSK)

  2FSK com fase contínua, $h=0.5$, $p$ retangular e símbolos $b[n]$ é equivalente a OQPSK com $p(t)=sin((pi t) / (2 T))$ e símbolos 

  $ a_i [n] = cases(
    -a_i [n-1] "se" b[n]!=b[n-1] \, n "ímpar",
    a_i [n-1]  "caso contrário"
  ) $

  $ a_q [n] = cases(
    -a_q [n-1] "se" b[n]!=b[n-1] \, n "par",
    a_q [n-1]  "caso contrário"
  ) $

  A esse caso especial de FSK (e de OQPSK) dá-se o nome MSK.
]

#slide[
  #align(center)[
    #image("msk_equivalence.png", width: 64%)
    #v(-1em)
    #text(size: 10pt)[Chaudhari, _Minimum Shift Keying (MSK) -- A Tutorial_, obtido de #link("https://www.dsprelated.com/showarticle/1016.php")[dsprelated.com].]
  ]
]

#slide[
  == Universal Asynchronous Receiver-Transmitter (UART)

  #align(center)[
    #image("modem_external_001_1.jpg", width: 66%)
    #v(-1em)
    #text(size: 10pt)[Imagine41, _U.S. Robotics 56K external modem_, obtido de #link("https://www.imagine41.com/product/u-s-robotics-56k-external-modem-power-adapter-cables/")[imagine41.com].]
  ]

  Usado para comunicação entre o modem de linha telefônica e o computador.
]

#slide[
  #align(center)[
    #image("uart_sig.png", width: 90%)
    #v(-1em)
    #text(size: 10pt)[Maxim, _Determining Clock Accuracy Requirements for UART Communications_, obtido de #link("https://pdfserv.maximintegrated.com/en/an/AN2141.pdf")[maximintegrated.com].]
  ]

  Sinal digital pode ser visto como uma modulação PAM OOK com pulsos retangulares no domínio do tempo.
  
  Ou seja, ineficiente para passar por um canal com banda limitada!
]

#slide[
  Para sincronizar o sinal no receptor, utiliza-se um relógio mais rápido que a taxa de transmissão e localiza-se a metade do pulso a partir da primeira queda de tensão do quadro (no _start bit_).
  
  #align(center)[
    #image("uart_sync.png", width: 66%)
    #v(-1em)
    #text(size: 10pt)[Maxim, _Determining Clock Accuracy Requirements for UART Communications_, obtido de #link("https://pdfserv.maximintegrated.com/en/an/AN2141.pdf")[maximintegrated.com].]
  ]
]

#slide[
  == UART: tolerância a erro de clock

  Para amostrar no centro do bit:

  #align(center)[
    $ 10 dot Delta T <= 0.5 T_"bit" $

    $ abs(Delta T)/T_"bit" <= 0.05 approx 5 % $
  ]

  - $5 %$: limite teórico, com oversampling tendendo a infinito.
  - Em 16x, a tolerância prática é menor pela menor precisão temporal.
]

#slide[
  == Breve histórico dos modems de linha telefônica
  #set text(size: 22pt)
  - *V.21* (1964, 300 bit/s): 2FSK simples, ainda no regime "um bit por símbolo".
  - *V.22* (1980, 1.2 kbit/s): salto de eficiência espectral com 600 baud e 2 bits por símbolo.
  - *V.32* (1984, até 9.6 kbit/s): cancelamento de eco + *TCM* bidimensional, rendendo cerca de *3.6 dB* de ganho de codificação.
  - *V.32bis* (1991, 14.4 kbit/s): mesma arquitetura básica, mas com expansão da constelação para subir a taxa mantendo *2400 baud*.
  - *V.34* (1994/1998, até 33.6 kbit/s): baud variável, probing, preênfase, shell mapping e um pré-codificador não linear acoplado ao Trellis.
  - *V.90* (1998, 56 kbit/s downstream): o salto final veio do PCM digital, não de um canal analógico "melhor".
]

#slide[
  == V.21 → V.22: o primeiro salto real

  #set text(size: 22pt)
  - *V.21:* 300 baud, 1 bit por símbolo, 2FSK.
  - *V.22:* 600 baud, 2 bits por símbolo, 4-DPSK, ainda em _full-duplex_ por FDM.
  - Conta da taxa já mostra o salto: $300 times 1 = 300$ bit/s → $600 times 2 = 1200$ bit/s.
  - O ganho veio principalmente de *dobrar a taxa simbólica* e usar uma modulação em quadratura mais eficiente em banda que FSK.
  - No V.21, o 2FSK fazia sentido pela simplicidade; no V.22, já valia usar um modem mais complexo para ganhar eficiência espectral.
  - O V.22bis depois amplia a constelação para 16-QAM, mas a ruptura conceitual principal já tinha acontecido no V.22.
]

#slide[
  == V.32 e V.32bis: a banda deixou de ser dividida

  #align(center)[
    #image("v32_echo_canceller.svg", width: 48%)
  ]

  #v(-1em)
  #set text(size: 17.8pt)
  - *V.22:* cada direção ocupava só uma parte da voz por FDM.
  - *V.32:* o cancelador de eco permite TX e RX simultâneos sobre praticamente toda a banda útil, e o *TCM* introduz cerca de *3.6 dB* de ganho de codificação.
  - *V.32bis:* mantém os mesmos *2400 baud* e a mesma ideia de TCM, mas amplia a constelação para chegar a *14.4 kbit/s*.
]

#slide[
  #align(center)[
    #image("photo_2026-02-13_08-57-29-2.jpg", width: 100%)
    #v(-1em)
    #text(size: 10pt)[Fotos de cabeamento telefônico: Guilherme Poletto, fevereiro de 2026.]
  ]
]

#slide[
  == Por que não bastava aumentar a potência?

  - Muitos pares compartilham o mesmo cabo: aumentar demais a potência eleva a diafonia (_cross-talk_) nos pares vizinhos.
  - Por isso os últimos kb/s não vieram de "gritar mais alto", e sim de ganhar margem em dB com codificação, shaping, equalização e uso mais inteligente da banda.
]

#slide[
  == V.34: não era "só aumentar a QAM"

  - O canal telefônico analógico já estava perto do limite: não dava para subir taxa só com mais potência ou mais pontos na constelação.
  - O salto do V.32bis para o V.34 veio da combinação de *mais baud*, *ganho de codificação* e *ganho de shaping*.
  - Em outras palavras: foi preciso otimizar ao mesmo tempo *a geometria da constelação*, *a sequência dos símbolos* e *a resposta do canal*.
]

#slide[
  #align(center)[#image("shaping_gain_illustration.svg", width: 88%)]
]

#slide[
  == Shell Mapping

  - Ideia central: escolher pontos *mais internos* com maior frequência e deixar os pontos externos mais raros.
  - Assim, a potência média cai sem reduzir a distância mínima entre vizinhos.
  - Esse _shaping gain_ rende cerca de *0.8 dB* no V.34, porque a norma limita a expansão da constelação a cerca de *25%*; o teto teórico seria ~*1.53 dB*.
]

#slide[
  == Pré-codificação não linear: combater ISI sem destruir o shaping

  #align(center)[#image("precoder_concept.svg", width: 100%)]
]

#slide[
  - Num DFE (Decision Feedback Equalizer) comum, decisões erradas no receptor entram no laço de realimentação e podem contaminar as próximas decisões.
  - O V.34 usa um *pré-codificador não linear* em malha de realimentação com o codificador Trellis 4D, historicamente ligado à linhagem THP/LTF, mas implementado na norma como uma arquitetura acoplada ao mapper/trellis.
]

#slide[
  == Baud rate adaptativo

  - Ao contrário do V.32bis, que fica fixo em *2400 baud*, o V.34 testa a linha e escolhe a taxa simbólica mais alta que ainda deixa margem suficiente.
  - A norma permite vários valores de baud; em linhas boas, o modem pode chegar ao teto de *3429 baud*.
  - Então o salto do V.34 tem duas partes: *mais símbolos por segundo* e *mais bits por símbolo*.
]

#slide[
  == Conta de padaria: por que 33.6 kb/s cabem

  - Linha telefônica boa: *SNR ~ 34 dB*
  - Alvo do V.34: $33600/3429 approx 9.8$ bits/símbolo
  - Aproximação: $"SNR"_("req,dB") approx 10 log_10(2^b - 1) + Gamma_"dB"$.

  #align(center)[
    #text(size: 22pt)[
      sem cod./shaping ($Gamma_"dB" approx 8.8$): 38.3 dB \
      com ganho do V.32/V.32bis (~3.6 dB): 34.7 dB \
      com ganhos extras do V.34 (~1.4 dB): 33.3 dB
    ]
  ]

  - Conclusão: *33.6 kbit/s* só começa a caber em linha típica quando entram os ganhos extras do *V.34*.
]

#slide[
  #align(center)[
    #image("pstn_digital_network.svg", width: 100%)
  ]
]

#slide[
  == V.90: o último salto não foi analógico

  - O _downstream_ explora a assimetria da rede: do provedor até a central o caminho já é digital/PCM.
  - O servidor faz uma forma de *PAM* sobre os níveis quantizados da G.711; o cliente ainda enxerga uma forma de onda analógica depois do DAC da central.
  - O teto ingênuo seria $8000 times 8 = 64$ kbit/s, mas vários níveis precisam ser descartados por potência, distância mínima e impairments digitais.
  - Por isso a norma chega a *56 kbit/s downstream*, enquanto o retorno continua essencialmente no mundo V.34.
]

#slide[
  == Por que implementar justamente o V.21?

  - Porque ele é o ponto de entrada mais simples para entender um modem completo: modulação, demodulação, sincronismo, framing e interface com a linha.
  - E ele não é "só uma curiosidade histórica": os sinais *CM/JM* da negociação *V.8* usam modulação *V.21* a *300 bit/s*, antes de sessões *V.32*, *V.34* ou *V.90*.
  - Ou seja, mesmo os modems mais avançados ainda dependem dessa base no começo da chamada.
  - Implementar o V.21 primeiro é aprender o alicerce sobre o qual os protocolos posteriores foram construídos.
]

#slide[
  == Prática: Implementação de um modem V.21

  - Modulação 2FSK a uma taxa de 300 símbolos por segundo, em ambas as direções.

  - Quem faz a chamada telefônica transmite bits zero ("espaço") na frequência de 1180 Hz, e transmite bits um ("marca") na frequência de 980 Hz.

  - Quem atende a chamada telefônica transmite bits zero ("espaço") na frequência de 1850 Hz, e transmite bits um ("marca") na frequência de 1650 Hz.
]

#slide[
  Fator de modulação:
  
  $ h = (1180-980)/300 = (1850-1650)/300 = 200/300 approx 0.67 $
]

#slide[
  Até aqui, discutimos *como codificar bits em sinais*.

  Para que um modem de linha telefônica funcione de verdade, ainda faltam três perguntas:

  - Como acoplar o circuito eletrônico à linha com \ segurança e isolação?
  - Como transmitir e receber ao mesmo tempo no mesmo \ par metálico?
  - O que acontece quando a impedância da linha real não é exatamente a que gostaríamos?
]

#slide[
  == Hardware de um modem de linha telefônica

  #align(center)[
    #image("wet_daa.svg", width: 64%)
    #v(-1em)
    #text(size: 10pt)[Adaptado de Randolph Telecom, _Transformer-based phone line interfaces_, obtido de #link("https://randolph-telecom.com/wp-content/uploads/2021/03/AN-5-Transformer-based-phone-line-interfaces-DAA-FXO-Rev1_IN-1300.pdf")[randolph-telecom.com].]
  ]
]


#slide[
  #align(center)[
    #image("dry_daa.svg", width: 70%)
    #v(-1em)
    #text(size: 10pt)[Adaptado de Randolph Telecom, _Transformer-based phone line interfaces_, obtido de #link("https://randolph-telecom.com/wp-content/uploads/2021/03/AN-5-Transformer-based-phone-line-interfaces-DAA-FXO-Rev1_IN-1300.pdf")[randolph-telecom.com].]
  ]
]

#slide[
  #align(center)[
    Híbrido
    
    #image("simple_hybrid.svg", width: 41%)
    #v(-1em)
    #text(size: 10pt)[Adaptado de National Semiconductor, _Optimal hybrid design_, obtido de #link("http://bitsavers.trailing-edge.com/components/national/_appNotes/AN-0397_Optimum_Hybrid_Design_Oct1999.pdf")[bitsavers.trailing-edge.com].]
  ]
]

#slide[
  #align(center+horizon)[
    #image("simple_hybrid2.svg", width: 49%)
  ]
]

#slide[
  #place(left+horizon)[
    #image("simple_hybrid3.svg", width: 49%)
  ]
  #place(right+horizon)[
    $ V_1=2V_2 - V_L <=> 2V_2 = V_1 + V_L$
    $ V_2=(V_1+V_O)/2 <=> V_O = 2V_2 - V_1 $
    $ V_O = V_L $
  ]
]

#slide[
  #align(center)[
    #image("hybrid_echo_demo.svg", width: 90%)
  ]
]

#slide[
  Limitações do híbrido na prática

  - Se $Z_L$ real for diferente da impedância de referência usada no híbrido, o cancelamento deixa um eco residual.
  - Esse eco atrapalha a recepção simultânea \ em sistemas _full-duplex_.
  - Modems mais avançados, como V.32 e V.34, usam \ _echo cancellation_ adaptativo para reduzir esse problema.
]

#slide[
  De volta à teoria de linhas de transmissão
  
  Substituindo a solução
  
  $ V(z)=V_0^+e^(-gamma z)+V_0^-e^(gamma z) $
  
  em
  
  $ (d V(z))/(d z) = -(R + j omega L) I(z) $

  temos

  $ -gamma V_0^+e^(-gamma z)+ gamma V_0^-e^(gamma z) = -(R + j omega L) I(z) $

  $ V_0^+e^(-gamma z) - V_0^-e^(gamma z) = (R + j omega L)/gamma I(z) $

  Identificamos 

  $ Z_0 = (R + j omega L)/gamma = (R + j omega L)/sqrt((R+j omega L)(G + j omega C)) $

  #v(1em)
  $ Z_0 = sqrt((R+j omega L)/(G + j omega C)) $
]

#slide[
  O que significa $Z_0$?

  - Posso trocar uma linha de transmissão com impedância característica $Z_0$ por um equivalente Thevenin de \ impedância $Z_0$? *Não!*

  #align(center)[#image("tline_thevenin1.svg", width: 80%)]
]

#slide[
  O que significa $Z_0$?

  - Posso trocar uma linha de transmissão com impedância característica $Z_0$ terminada com uma carga de impedância $Z_0$ por um equivalente Thevenin de impedância $Z_0$? *Sim*

  #align(center)[#image("tline_thevenin2.svg", width: 80%)]
]

#slide[
  O que acontece se a carga não for igual a $Z_0$?

  - A impedância vista na entrada da linha deixa de ser apenas $Z_0$.
  - Ela passa a depender de *duas coisas*: da impedância característica da linha e da impedância da carga na outra extremidade.
  - Diz-se então que a linha pode atuar como um *transformador de impedância*.
  - Às vezes isso atrapalha, porque produz reflexões; em outros casos pode ser útil e até desejado.
  - Essa ideia voltará quando estudarmos casamento de impedância e antenas.
]

#slide[
  Reflexões na carga

  #align(center)[
    $ Gamma = (Z_L - Z_0)/(Z_L + Z_0) $
  ]

  #set text(size: 21pt)
  - Carga casada: $Z_L = Z_0 => Gamma = 0$
  - Circuito aberto: $Z_L -> infinity => Gamma = +1$
  - Curto-circuito: $Z_L = 0 => Gamma = -1$

  #v(0.3em)
  #align(center)[
    $ "VSWR" = (1 + abs(Gamma))/(1 - abs(Gamma)) $
  ]

  - Quanto menor $abs(Gamma)$, melhor o casamento de impedância; isso será importante nas práticas com linhas, híbridos e antenas.
]

#slide[
  Problema: a impedância da linha telefônica não é bem padronizada
  #align(center)[
    #image("phone_line_impedance.png", width: 70%)
    #v(-1em)
    #text(size: 10pt)[National Semiconductor, _Optimal hybrid design_, obtido de #link("http://bitsavers.trailing-edge.com/components/national/_appNotes/AN-0397_Optimum_Hybrid_Design_Oct1999.pdf")[bitsavers.trailing-edge.com].]
  ]
]

#slide[
  National Semiconductor, _Optimal hybrid design_, disponível em #link("http://bitsavers.trailing-edge.com/components/national/_appNotes/AN-0397_Optimum_Hybrid_Design_Oct1999.pdf")[bitsavers.trailing-edge.com], apresenta uma abordagem para projetar um híbrido que funciona da melhor maneira possível para um intervalo de impedâncias $Z_L$.
]

#slide[
  == Conclusão

  #set text(size: 24pt)
  - Começamos com os limites fundamentais: ruído, SNR e capacidade.
  - Depois vimos como diferentes modulações trocam *eficiência espectral*, *robustez* e *complexidade*.
  - Na telefonia, os saltos históricos vieram de ideias cada vez mais sofisticadas: cancelamento de eco, codificação, shaping, precoding e uso assimétrico da rede.
  - Por fim, voltamos ao mundo físico: linha, híbrido, reflexões e impedância também fazem parte do problema.
  - As práticas vão justamente costurar essas duas visões: \ *DSP + circuito + canal real*.
]
