# Notas de apoio — Módulo 3

## Slide 1 — Capa

- O fio condutor do módulo é mostrar que Ethernet não é apenas formato de quadro: é uma família de contratos entre MAC, PHY, meio físico, temporização e compatibilidade histórica.
- Vale antecipar a tensão central do módulo: o quadro Ethernet mudou pouco, mas a forma de colocar bits no meio físico mudou radicalmente de 10 Mbit/s a 100G+.

## Slide 2 — Objetivos deste módulo

- As perguntas combinam três camadas de raciocínio: acesso ao meio, estrutura do quadro e implementação física.
- O objetivo didático não é decorar todas as PHYs, mas enxergar por que cada salto de velocidade exigiu uma nova solução de codificação, equalização, SerDes, DSP ou FEC.

## Slide 3 — Do E1 ao Ethernet: mudança de paradigma

- O contraste mais importante é entre circuito/time slot fixo e pacote sob demanda.
- No E1, a posição no quadro tem significado permanente. No Ethernet, o destino viaja dentro do próprio quadro, por endereço MAC.
- A comparação ajuda a explicar por que Ethernet precisa de preâmbulo, SFD, FCS e regras de acesso ao meio: o receptor não está preso a um fluxo TDM rigidamente enquadrado.

## Slide 4 — Pipeline da Prática 3: visão de sistema

- A prática é uma implementação mínima de um nó 10BASE-T half-duplex, não uma NIC comercial completa.
- A cadeia RX reconstrói progressivamente: tensão diferencial, amostras, bits Manchester, fronteira SFD, bytes Ethernet e campos ARP.
- A cadeia TX mostra o caminho inverso: montar quadro, calcular FCS, serializar bits LSB-first, codificar Manchester, respeitar IPG, detectar colisão e transmitir no par diferencial.

## Slide 5 — Linha do tempo: uma mesma MAC, muitas PHYs

- Este slide deve ser lido como evolução de engenharia, não como lista histórica.
- A MAC permanece relativamente estável enquanto a PHY muda de coaxial compartilhado para UTP, fibra, SerDes, DSP e óptica coerente/PAM4.
- A mensagem principal é que compatibilidade não significa imobilidade: Ethernet sobreviveu porque separou o contrato de quadro do contrato físico.

## Slide 6 — Ideia central: separar MAC e PHY

- A separação MAC/PHY permite trocar o meio físico sem redesenhar o formato de quadro e os protocolos acima.
- Em implementação moderna, essas camadas podem estar no mesmo chip, mas continuam existindo como fronteiras funcionais do padrão.
- Em cobre RJ45 barato, MAC/PCS/PMA/PMD tendem a ser integrados. Em óptica com SFP/QSFP, a separação volta a ser fisicamente visível.

## Slide 7 — Dentro da PHY: PCS, PMA, PMD e MDI

- PCS é onde aparecem códigos de linha, blocos de controle, scrambling e FEC.
- PMA é a região de SerDes, CDR, alinhamento de bits e lanes.
- PMD é a parte dependente do meio: laser, fotodiodo, TIA, driver, equalização analógica ou interface com par trançado.
- MDI é o ponto físico de contato com o mundo externo: RJ45, par diferencial, fibra, backplane ou DAC.

## Slide 8 — De ALOHA para Ethernet

- A inovação do Ethernet clássico foi transformar um canal compartilhado caótico em um canal compartilhado com disciplina local: escutar, transmitir, detectar colisão e recuar.
- A ideia de “ether” era literal no barramento coaxial: todos ouviam o mesmo sinal elétrico.

## Slide 9 — Pure ALOHA e Slotted ALOHA

- Pure ALOHA tem janela vulnerável de dois tempos de quadro porque outro quadro pode começar antes ou durante a transmissão observada.
- Slotted ALOHA reduz a janela vulnerável para um tempo de quadro ao sincronizar os inícios de transmissão.
- A comparação prepara CSMA/CD: Ethernet melhora ALOHA porque não transmite cegamente quando já percebe portadora.

## Slide 10 — CSMA/CD: o salto conceitual

- Carrier sense reduz colisões, mas não as elimina, porque a propagação do sinal leva tempo.
- Collision detect é a diferença prática: a estação precisa perceber a colisão enquanto ainda está transmitindo.
- O jam existe para garantir que a colisão fique observável por todos os participantes do domínio compartilhado.

## Slide 11 — Por que existe tamanho mínimo de quadro?

- O tamanho mínimo de 64 bytes vem do requisito de detectar colisão no pior atraso de ida e volta do domínio de colisão.
- A conta `64 bytes × 8 = 512 bit times` é sobre o MAC frame, do destino ao FCS, sem contar preâmbulo e SFD.
- Em Ethernet full-duplex moderna, a razão física desapareceu, mas o tamanho mínimo permaneceu por compatibilidade.

## Slide 12 — Backoff exponencial binário

- O backoff não tenta resolver colisão por prioridade fixa; ele espalha probabilisticamente as novas tentativas.
- A janela cresce com o número de colisões, reduzindo a probabilidade de colisões repetidas sob carga.
- Na prática, o LFSR é suficiente para materializar a ideia sem precisar de uma fonte randômica sofisticada.

## Slide 13 — 10BASE5 e 10BASE2: o barramento físico

- Coaxial em barramento deixa claro por que a Ethernet original era realmente um meio compartilhado.
- Terminadores são parte do funcionamento, não acessório: sem terminação correta, reflexões corrompem o sinal.
- Falhas físicas no barramento são globais; isso motiva a migração para estrela física com hubs e depois switches.

## Slide 14 — AUI e MAU: modularidade antes do RJ45

- AUI/MAU já expressava a ideia de separar controlador e transceptor físico.
- A analogia com GBIC/SFP/QSFP é útil: o equipamento principal não precisa embutir todos os meios físicos possíveis.
- A modularidade tem custo de interface, mas compra longevidade e flexibilidade.

## Slide 15 — 10BASE-T: estrela física, barramento lógico

- O hub muda a topologia física, mas não elimina o domínio de colisão: ele é um repetidor multiporta.
- A falha de um cabo passa a afetar uma estação, não o barramento inteiro.
- Para a prática, o hub é importante porque torna CSMA/CD observável; com switch full-duplex, RX durante TX não é colisão.

## Slide 16 — Full-duplex: quando colisão deixa de existir

- Em enlace ponto-a-ponto com switch, os dois sentidos podem transmitir simultaneamente sem disputar o meio.
- CSMA/CD só é coerente com meio compartilhado half-duplex.
- A Ethernet cotidiana preserva IPG, quadro, endereços e FCS, mas não usa colisões como mecanismo normal.

## Slide 17 — Quadro Ethernet

- O preâmbulo e o SFD não fazem parte do MAC frame protegido pelo FCS; eles são ajuda física/de sincronismo.
- O payload mínimo existe para manter o quadro total dentro do tamanho mínimo histórico.
- O campo Type/Length é uma herança compatível: pode indicar EtherType ou comprimento, conforme o valor.

## Slide 18 — Ordem de bits: detalhe que quebra implementações

- Ethernet transmite cada octeto LSB-first no meio físico.
- `0x55` não denuncia erro de ordem porque é alternado em qualquer direção; `0xD5` denuncia, porque no fio aparece como `10101011`.
- Esse detalhe impacta diretamente desserialização, CRC refletido e interpretação de campos na prática.

## Slide 19 — Endereçamento Ethernet

- O bit individual/grupo é o bit menos significativo do primeiro octeto na ordem lógica, mas é também o primeiro bit transmitido no fio.
- Broadcast é o caso extremo de grupo: todos os bits em 1.
- O MAC da prática é fixo e didático; em equipamentos reais, há OUIs administrados e também endereços localmente administrados.

## Slide 20 — Ethernet ainda precisaria de MAC address?

- Em enlaces full-duplex ponto-a-ponto, o endereço MAC não é fisicamente necessário para entregar ao outro lado do cabo.
- Ele permanece porque switches, bridges, VLANs, ARP/ND, drivers e décadas de protocolos dependem desse contrato.
- Este é um bom exemplo de “peso histórico útil”: nem tudo que permanece é exigência física atual.

## Slide 21 — ARP: aplicação mínima para testar o enlace

- ARP é ideal para a prática porque usa Ethernet diretamente e permite resposta visível sem pilha IP completa.
- A FPGA precisa reconhecer poucos campos fixos, copiar MAC/IP do solicitante e montar a resposta.
- Isso mostra que um sistema de rede útil pode ser demonstrado com uma MAC mínima e uma aplicação de enlace bem escolhida.

## Slide 22 — FCS Ethernet: CRC-32 em hardware

- O CRC cobre o MAC frame, não preâmbulo nem SFD.
- Como os bits chegam LSB-first, a implementação natural usa o polinômio refletido `0xedb88320`.
- O CRC é divisão polinomial em `GF(2)`: em hardware, isso vira deslocamento e XOR, sem carries.

## Slide 23 — 10BASE-T: forma de onda Manchester

- Manchester troca eficiência espectral por recuperação de clock simples.
- Há transição obrigatória no meio de cada bit; transições extras na fronteira entre bits iguais não representam novo bit.
- A convenção da prática precisa ser mantida em TX e RX: transição ascendente no meio representa `1`, descendente representa `0`.

## Slide 24 — Receptor Manchester: o que implementar

- O receptor não recebe “bits”; recebe uma forma de onda que precisa ser fatiada, temporizada e interpretada.
- A transição central é dado e clock ao mesmo tempo.
- A prática implementa uma recuperação de fase simples, suficiente para bancada, em vez de uma PLL/CDR comercial completa.

## Slide 25 — AFE discreto da Prática 3

- O RJ45 com magnetics não é só conector: fornece isolamento galvânico e acoplamento AC.
- No RX, como o transformador remove referência DC, a prática cria um bias local para o buffer diferencial do FPGA.
- No TX, os pinos complementares e resistores série excitam o transformador de forma suficiente para cabos curtos de laboratório.
- É importante não vender isso como PHY certificável de 100 m; é um AFE didático que abre a caixa-preta.

## Slide 26 — Normal Link Pulses

- Em 10BASE-T, o enlace ocioso não carrega idle contínuo como em PHYs modernas; ele envia pulsos isolados de presença.
- A ordem de grandeza é pulso de cerca de 100 ns a cada cerca de 16 ms.
- A prática gera NLPs para que a outra ponta perceba link mesmo sem quadros.

## Slide 27 — Fast Link Pulses (FLP) e autonegociação

- FLP preserva compatibilidade: equipamento antigo vê pulsos de link; equipamento novo decodifica capacidade.
- A autonegociação anuncia modos 10/100, half/full, pause e extensões.
- Em Gigabit cobre, autonegociação também resolve master/slave, necessário para temporização e treinamento.
- A ideia física é simples: em vez de mandar um único Normal Link Pulse a cada cerca de 16 ms, a PHY manda uma rajada curta de pulsos. Essa rajada ainda parece, para uma PHY 10BASE-T antiga, uma sequência válida de pulsos de presença de link.
- Dentro da rajada FLP há 17 posições de clock, sempre preenchidas por pulsos. Entre duas posições de clock existe uma posição opcional de dado. Se há pulso nessa posição intermediária, o bit vale `1`; se não há pulso, o bit vale `0`.
- Portanto, presença/ausência não significa “tem link”/“não tem link” dentro da rajada. O link é indicado pela repetição das rajadas; a presença ou ausência nas posições intermediárias é a codificação dos bits da palavra de autonegociação.
- Cada rajada carrega uma palavra de 16 bits, chamada Link Code Word. Os pulsos de clock dão referência temporal para o receptor saber onde procurar cada uma das 16 oportunidades de pulso de dado.
- No diagrama “sample pulse”, os primeiros 5 bits são o Selector Field. Para Ethernet IEEE 802.3, o selector anunciado é `00001`, transmitido LSB-first; por isso aparece apenas o primeiro pulso de dado desse campo.
- Os bits seguintes formam o Technology Ability Field. No exemplo, os pulsos presentes anunciam suporte a `10BASE-T half`, `10BASE-T full`, `100BASE-TX half`, `100BASE-TX full` e `Pause`. A ausência de pulso em `100 T4`, `Asym. Pause` etc. significa que aquela capacidade não está sendo anunciada.
- `Remote Fault` indica que a outra ponta detectou uma falha remota. `ACK` é ligado depois que a PHY recebeu palavras consistentes do parceiro. `NP` (_Next Page_) indica que virão páginas adicionais para negociar informações que não cabem nessa palavra básica.
- A negociação escolhe o melhor modo comum entre os dois anúncios, usando a ordem de prioridade do padrão; não é simplesmente “o maior número que alguém anunciou”.

## Slide 28 — CSMA/CD na Prática 3

- Carrier sense é estimado por atividade Manchester no RX.
- Colisão é modelada como RX ativo durante TX, o que só é válido em cenário half-duplex com hub.
- O jam, slot time e backoff da prática são simplificações, mas preservam a dinâmica essencial de CSMA/CD.

## Slide 29 — 100BASE-TX: Fast Ethernet sobre cobre

- 100BASE-TX não aumenta a velocidade apenas “rodando Manchester mais rápido”; ele troca completamente a codificação física.
- O caminho conceitual é `MII -> 4B/5B -> scrambling -> MLT-3 -> cabo`.
- O objetivo do MLT-3 e do scrambler é controlar espectro, EMI e comportamento no cabo Cat 5.

## Slide 30 — 4B/5B: transições e controle

- A conta `100 Mbit/s × 5/4 = 125 Mbaud` é taxa de símbolos da codificação, não taxa útil de payload Ethernet.
- 4B/5B compra densidade de transições e símbolos de controle ao custo de 25% de overhead na linha.
- O idle `/I/ = 11111` seria altamente periódico; por isso o scrambler é necessário antes do MLT-3 em 100BASE-TX.

## Slide 31 — NRZI e MLT-3

- NRZI transforma bits em decisão de transição: `1` muda, `0` mantém.
- MLT-3 limita os saltos de tensão ao ciclo `0 -> +1 -> 0 -> -1 -> 0`, evitando transição direta entre `+1` e `-1`.
- Um trem de `1`s a 125 MBd completa um ciclo MLT-3 em quatro símbolos: `T0 = 4Ts`; como `Ts = 8 ns`, `f0 = 1/(32 ns) = 31,25 MHz`.
- A frase “cabe melhor no Cat 5” significa que a energia dominante fica bem abaixo da certificação de 100 MHz do Cat 5, em vez de concentrar um tom em 125 MHz.

## Slide 32 — Scrambler: não é criptografia, é espectro

- O scrambler espalha energia espectral e reduz padrões periódicos longos; ele não oferece sigilo.
- Em 100BASE-TX, o LFSR de 11 bits gera uma sequência pseudoaleatória que é combinada por XOR com os bits.
- A nuance prática é que implementações modernas podem otimizar internamente conversões redundantes descritas por fronteiras históricas do padrão; o contrato externo continua sendo o mesmo.

## Slide 33 — 100BASE-TX: blocos de uma PHY implementável

- A separação NRZI/NRZ no diagrama reflete fronteiras funcionais e heranças de FDDI/100BASE-TX, não necessariamente blocos físicos separados em uma NIC moderna.
- Em um ASIC atual, síntese lógica pode eliminar uma ida e volta `NRZ -> NRZI -> NRZ` se ela for redundante.
- Ainda assim, o padrão descreve PCS/PMA/PMD porque precisa especificar interoperabilidade, não o layout interno do silício.
- Baseline wander aparece porque magnetics bloqueiam DC; códigos e compensação precisam manter a decisão do receptor centrada.

## Slide 34 — O cabo agora manda no projeto

- Em 100BASE-TX e acima, o cabo é um canal analógico com perda dependente de frequência, ISI e acoplamento AC.
- Equalização insuficiente deixa símbolos borrados; equalização excessiva cria overshoot/ringing.
- Uma PHY comercial estima o canal e ajusta filtros, mesmo quando o resultado final ainda parece “só bits” para a MAC.

## Slide 35 — Quando o AFE deixa de bastar?

- O AFE nunca desaparece; o que muda é onde a decisão binária ou multinível é feita.
- Em 10BASE-T, comparador e Manchester bastam para fins didáticos.
- Em 1000BASE-T e 10GBASE-T, o receptor vira um modem com ADC/DAC, canceladores, equalizadores adaptativos e treinamento.
- Em fibra NRZ simples, muitas vezes um AFE com TIA, slicer e CDR basta; em PAM4 moderno, DSP e FEC tornam-se centrais.

## Slide 36 — 100BASE-FX: mesma taxa, outro meio

- 100BASE-FX reaproveita 4B/5B, mas não precisa de MLT-3 porque a fibra suporta banda maior e não irradia EMI como cobre.
- O PMD muda de driver elétrico para laser/fotodiodo, orçamento óptico, limiar e CDR.
- A MAC não precisa saber se o bit veio de cobre ou fibra; essa é a força da separação em camadas.

## Slide 37 — 1000BASE-X: Gigabit em fibra

- 1000BASE-SX é 850 nm em multimodo para curto alcance; 1000BASE-LX é 1310 nm e é a exceção clássica que pode operar em multimodo ou monomodo.
- Em multimodo com 1000BASE-LX, pode ser necessário cabo de condicionamento de modo para reduzir DMD ao lançar luz de um laser 1310 nm em núcleo multimodo.
- 8B/10B tem overhead de 25% sobre dados úteis: 1 Gbit/s vira 1,25 Gbaud.
- Running disparity é a conta acumulada entre `1`s e `0`s transmitidos; ela mantém balanço DC e permite detectar violações de código antes mesmo do FCS.

## Slide 38 — Conceitos de fibra que entram na PHY

- Multimodo sofre dispersão modal: modos diferentes percorrem caminhos diferentes e chegam em tempos diferentes.
- Monomodo reduz dispersão modal e por isso domina redes de acesso, PON, enlaces metropolitanos e longas distâncias.
- A figura de LED vs VCSEL deve ser lida como `mode fill`: LED tende a lançar luz em cone mais largo e excitar muitos modos; VCSEL (`Vertical-Cavity Surface-Emitting Laser`, laser de emissão superficial com cavidade vertical) concentra melhor o lançamento e excita menos modos periféricos, reduzindo dispersão modal em multimodo.
- Em fibra multimodo `step-index`, o índice de refração muda abruptamente na fronteira núcleo/casca; raios inclinados percorrem caminho maior praticamente na mesma velocidade e chegam atrasados.
- Em fibra multimodo `graded-index`, o índice é maior no centro e menor perto da borda; raios que percorrem caminho maior viajam mais rápido nas regiões de menor índice, compensando parte do atraso modal.
- GPON e XGS-PON usam fibra monomodo, tipicamente G.652.D ou G.657, com WDM em comprimentos de onda distintos para subida e descida.
- Dispersão cromática importa porque mesmo lasers têm largura espectral finita; comprimentos de onda ligeiramente diferentes viajam a velocidades diferentes e alargam pulsos, causando ISI em altas taxas ou longas distâncias.
- A largura espectral do laser não contradiz `E = hν`: lasers semicondutores têm bandas de energia, tempo de vida finito dos estados, efeitos térmicos e modos de cavidade, produzindo uma linha estreita, mas não infinitamente fina.

## Slide 39 — 1000BASE-T: Gigabit em quatro pares

- 1000BASE-T é um salto conceitual: todos os quatro pares transmitem e recebem simultaneamente.
- O receptor precisa subtrair o eco do próprio transmissor e cancelar diafonia dos outros pares.
- A PHY deixa de parecer um codificador de linha simples e passa a parecer um modem adaptativo multicanal.

## Slide 40 — Conta de engenharia do 1000BASE-T

- `MBd` significa megabaud: milhões de símbolos por segundo, não megabytes nem megabits.
- Baud rate mede quantas decisões/símbolos físicos são enviados por segundo; bit rate mede informação lógica por segundo.
- A conta didática é `125 Msym/s × 4 pares × 2 bits/símbolo = 1000 Mbit/s`.
- PAM5 tem cinco níveis; a folga além dos quatro estados de 2 bits por par é usada pela codificação conjunta e robustez.

## Slide 41 — Full-duplex no mesmo par: eco controlado

- Cada receptor vê a soma do sinal remoto desejado, eco local, diafonia dos pares e ruído.
- O transmissor local é conhecido, então seu eco pode ser estimado e subtraído por filtro adaptativo.
- O problema é dinâmico: cabo, conectores, temperatura e frequência alteram a resposta do canal.

## Slide 42 — Master/slave e treinamento

- Master/slave em 1000BASE-T não é hierarquia de rede; é referência de temporização para o PHY.
- Antes de dados úteis, as pontas treinam filtros de eco, NEXT, equalização e ganho.
- Esse treinamento é o preço de usar quatro pares comuns de Cat 5 em full-duplex simultâneo.

## Slide 43 — 10GBASE-T: o limite do cobre fica caro

- 10GBASE-T mantém a promessa de 100 m em cobre, mas paga com DSP intenso, FEC, PAM16 e canceladores longos.
- A taxa simbólica de 800 MBd por par aumenta muito a sensibilidade a perdas, alien crosstalk e linearidade do AFE.
- O projeto passa a ser dominado por área, potência e verificação dos blocos de sinal.

## Slide 44 — 10 Gigabit Ethernet em fibra

- 10GbE óptico abandona half-duplex e opera como enlace serial full-duplex.
- 10GBASE-R usa 64B/66B e cerca de 10,3125 Gbaud, reduzindo overhead em relação a 8B/10B.
- SR é multimodo 850 nm; LR e ER são monomodo em 1310/1550 nm para alcances maiores.
- LX4 é historicamente interessante por usar WDM para compatibilidade com fibras instaladas.

## Slide 45 — 64B/66B: overhead pequeno, CDR ainda possível

- 64B/66B reduz o overhead para aproximadamente 3,125%, mas precisa de scrambler para manter transições suficientes.
- Os dois bits de cabeçalho não são embaralhados da mesma forma que o payload e permitem block lock.
- O receptor precisa primeiro encontrar fronteiras de bloco confiáveis antes de entregar dados à MAC.

## Slide 46 — Interfaces internas: MII até SerDes

- Interfaces paralelas simples funcionam em 100M/1G, mas escalam mal em pinos e temporização.
- XAUI foi uma solução intermediária: menos pinos usando quatro lanes SerDes.
- Em velocidades modernas, a fronteira entre MAC e PHY costuma ser serial de alta velocidade, com equalização e CDR já no próprio enlace de chip para módulo ou chip para chip.

## Slide 47 — Módulos ópticos: onde termina o chip?

- SFP/QSFP materializam a separação entre host e PMD: o host fornece SerDes, controle e alimentação; o módulo fornece óptica e parte analógica.
- Em velocidades maiores, a fronteira se desloca: alguns módulos incluem CDR, DSP e até FEC parcial.
- Para identificar transceptores, os sinais mais confiáveis são padrão/modelo, comprimento de onda, alcance e marcações SMF/MMF. `SR/SX` geralmente indica multimodo curto; `LR/ER/ZR` geralmente monomodo.
- A regra “850 nm é multimodo; 1310/1550 nm é monomodo” tem exceções históricas, especialmente 1000BASE-LX em multimodo.

## Slide 48 — 40G e 100G: paralelismo primeiro

- Antes de aumentar brutalmente a velocidade por lane, a solução prática foi agregar lanes.
- O PCS distribui dados e insere marcadores para permitir deskew no receptor.
- O deskew é necessário porque cada lane/fibra/comprimento de onda pode ter atraso diferente.

## Slide 49 — PAM4: quando NRZ deixa de escalar bem

- PAM4 carrega 2 bits por símbolo, reduzindo o baud rate necessário para a mesma taxa de bits.
- A penalidade é geométrica: quatro níveis criam três olhos menores e reduzem margem vertical.
- Por isso PAM4 exige melhor SNR, linearidade, equalização e FEC; não é “NRZ duas vezes melhor”, é outro compromisso.

## Slide 50 — 100G moderno: exemplo de PHY PAM4

- 100GBASE-DR/FR/LR mostram a convergência moderna: uma lane óptica PAM4, DSP e FEC como partes essenciais.
- DR/FR/LR diferem principalmente por alcance e orçamento óptico, não pela MAC.
- A decisão no receptor pode envolver ADC ou comparadores multinível, equalização e CDR acoplados.

## Slide 51 — FEC em Ethernet moderna

- CRC detecta erro e descarta quadro; FEC corrige erros antes que a MAC veja o quadro.
- Em enlaces PAM4, operar sem FEC exigiria margens físicas caras ou inviáveis.
- O custo da FEC é latência, área, potência e complexidade de validação.

## Slide 52 — Cobre moderno: backplane e DAC

- Cobre moderno de alta velocidade muitas vezes não é RJ45 de 100 m, mas trilha de backplane ou cabo twinax curto.
- O problema se parece com projeto de SerDes: perdas em alta frequência, reflexões, jitter, CTLE, FFE, DFE e CDR.
- PAM4 reduz baud, mas piora margem vertical e exige calibração cuidadosa.

## Slide 53 — Se fôssemos implementar em silício: caminho essencial

- A tabela é um mapa de complexidade crescente: de comparadores e Manchester até DSP, FEC, SerDes e óptica avançada.
- Uma boa leitura é perguntar, para cada tecnologia, qual bloco novo aparece porque o meio físico deixou de tolerar a solução anterior.
- O objetivo é formar intuição de implementação, não transformar o módulo em catálogo de padrões.

## Slide 54 — Conceitos teóricos que viram transistores

- Cada conceito listado vira bloco real: PLL/CDR vira laço de temporização; GF(2) vira XOR; equalização vira filtros; orçamento óptico vira potência de laser e sensibilidade.
- A ponte entre teoria e transistor é a ideia central da disciplina: telecomunicações não termina na equação, precisa fechar margem em hardware.

## Slide 55 — O que a Prática 3 simplifica de propósito

- As simplificações são escolhas pedagógicas: removem autonegociação, full-duplex, validação completa de FCS no RX e PHYs modernas para manter a implementação legível.
- O que fica é o núcleo conceitual: forma de onda, sincronismo, quadro, CRC no TX, ARP e CSMA/CD observável.

## Slide 56 — Comparação de formas de onda

- A tabela deve ser lida como “por que esta forma de onda foi escolhida para este canal”.
- Manchester privilegia clock; MLT-3 privilegia espectro em Cat 5; NRZ/8B10B privilegia SerDes e balanço DC; PAM5/PAM16/PAM4 privilegiam bits por símbolo sob DSP/FEC.
- Não existe código universalmente melhor; existe compromisso adequado ao meio, à taxa e ao custo.

## Slide 57 — A Prática 3 como microcosmo da Ethernet

- A prática contém versões pequenas dos problemas reais: fatiar sinal, recuperar temporização, delimitar quadro, respeitar bit order, calcular FCS e lidar com contenção.
- Mesmo que PHYs modernas sejam muito mais complexas, a arquitetura mental é a mesma: transformar fenômeno físico em bits confiáveis dentro de um contrato de enlace.

## Slide 58 — Síntese

- A síntese deve reforçar continuidade e ruptura: a Ethernet preserva quadro e endereçamento, mas troca repetidamente a física abaixo.
- CSMA/CD explica a origem histórica; switches full-duplex explicam o uso atual; PHYs modernas explicam por que implementação virou projeto de sinal e silício.

## Slide 59 — Como ler a prática

- A leitura da prática deve seguir o fluxo de dados, não a ordem dos arquivos.
- Perguntas-guia úteis: onde a tensão vira bit, onde o preâmbulo sincroniza, onde o SFD libera bytes, onde a ordem LSB-first aparece, onde o FCS é calculado e onde CSMA/CD altera o transmissor.
- O objetivo final é que o aluno consiga apontar cada conceito do slide para um bloco observável de hardware ou código.

## Observações complementares

- Multimodo ainda aparece em data centers e infraestrutura legada por base instalada, alcance curto e VCSELs baratos/eficientes. Mas essa vantagem econômica ficou mais estreita: hoje alinhamento, conectorização e acoplamento óptico de monomodo já são processos industriais maduros, então a diferença só pesa claramente em escala muito grande ou quando a instalação MMF já existe.
- Cuidado com a frase “fibra multimodo é mais barata”: hoje o vidro monomodo em si pode ser mais simples/barato; quando multimodo ganha, normalmente é no sistema completo de curtíssimo alcance, por VCSELs e tolerâncias ópticas mais relaxadas, não por uma superioridade intrínseca do cabo.
- Em projetos novos de hyperscale, é comum preferir monomodo mesmo dentro do data center, especialmente em 100G/400G+ e arquiteturas com WDM/PSM, porque padronizar em uma fibra com maior alcance reduz variantes, estoque, migrações e complexidade operacional. Isso não elimina MMF em short-reach, mas muda a mensagem: multimodo é uma otimização local de custo/energia, não a escolha “natural” para qualquer data center moderno.
- Conectores LC/SC/MPO não determinam sozinhos se o enlace é monomodo ou multimodo. O que determina é o transceiver, o comprimento de onda, o alcance e a fibra especificada.
- Mode-conditioning patch cord não “expande luz pelo conector”; ele desloca o lançamento do laser em fibra multimodo para reduzir excitação ruim de modos e mitigar DMD em 1000BASE-LX sobre MMF.
- Em MLT-3, a conta simples de 31,25 MHz é análise de pior caso periódico. Para dados reais, o espectro depende das estatísticas após 4B/5B e scrambling; não convém ensinar uma fórmula de PSD sem deixar claro o modelo estatístico assumido.
- Running disparity em 8B/10B é simultaneamente mecanismo de balanço DC e verificação de validade: um símbolo pode existir na tabela, mas estar errado se aparecer com a disparidade incompatível.

## Referências

- IEEE 802.3, especificação de Ethernet, especialmente seções de MAC, 10BASE-T, 100BASE-TX, 1000BASE-X, 1000BASE-T e PHYs de alta velocidade.
- Charles E. Spurgeon, *Ethernet: The Definitive Guide*, O'Reilly, 2000.
- Rich Seifert e Jim Edwards, *The All-New Switch Book*, Wiley, 2008.
- Digital Equipment Corporation, Intel, Xerox, *The Ethernet: A Local Area Network: Data Link Layer and Physical Layer Specifications*, versão 2.0, 1982.
- UNH InterOperability Laboratory, *Ethernet Evolution From 10 Meg to 10 Gig*.
- UNH InterOperability Laboratory, *100BASE-TX PMD*.
- RFC 826, *An Ethernet Address Resolution Protocol*, 1982.
