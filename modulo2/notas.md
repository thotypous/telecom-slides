# Notas de apoio — Módulo 2

## Slide 1 — Capa

- O fio condutor do módulo é ir do fenômeno físico no cabo até a resposta lógica ao `ping`.
- Vale explicitar desde o começo que a prática mistura três camadas que costumam ser ensinadas separadamente: física, enlace e aplicações mínimas.

## Slide 2 — Objetivos deste módulo

- As perguntas dos objetivos já antecipam a organização do pipeline: relógio, bits, timeslots, quadros e resposta ao pacote.
- Uma boa leitura pedagógica é mostrar que cada bloco existe para remover uma ambiguidade diferente do sinal recebido.

## Slide 3 — Pipeline da Prática 2: visão de sistema

- O pipeline é quase todo uma cadeia de “reconstruções”: instante de amostragem, bit binário, fronteira de quadro E1, fronteira de quadro HDLC e conteúdo útil.
- O `ICMPReplier` é pequeno em funcionalidade, mas importante didaticamente porque mostra que o enlace não termina na recuperação do sinal: ele alimenta um sistema de rede real.

## Slide 4 — Voz, sinalização e dados: tudo no mesmo E1

- O E1 nasceu no contexto PCM para telefonia, mas a mesma estrutura TDM acabou sendo reutilizada para dados síncronos e integrações voz/dados.
- Em equipamentos de mercado, era comum particionar timeslots entre voz e dados, em vez de dedicar o enlace inteiro a um único serviço.

## Slide 5 — Notação do módulo 1 (recapitulação rápida)

- A expressão `x(t) = sum a[n] p(t-nT)` continua útil porque HDB3 e os pulsos físicos ainda são escolhas de forma de onda em banda base.
- A diferença é que, neste módulo, a sequência `a[n]` já não vem “crua”: ela carrega estrutura de enlace e restrições de sincronização.

## Slide 6 — De voz analógica a 64 kbit/s

- A banda telefônica clássica é limitada aproximadamente a 300–3400 Hz, e a amostragem a 8 kHz atende ao critério de Nyquist com folga prática para voz.
- O canal PCM de 64 kbit/s é a unidade básica de multiplexação da hierarquia PDH europeia.
- Em telefonia, a escolha histórica de `125 µs` por quadro é tão central que reaparece em toda a família E1.

## Slide 7 — Lei A e lei µ: por que companding?

- Com apenas 8 bits por amostra, a quantização linear degradaria perceptivelmente os sinais fracos; o companding redistribui os níveis para melhorar o desempenho perceptual.
- No E1, a lei A é a escolha histórica da família G.711; no T1, predomina a lei µ.
- Convém formular com cuidado: a motivação principal é melhorar a relação sinal/ruído de quantização para sinais de menor amplitude, não “imitar exatamente” a audição humana.

## Slide 8 — Por que 2,048 Mbit/s?

- A conta `32 × 8 / 125 µs` fecha a taxa bruta do enlace, não apenas a parte útil.
- O valor de `2,048 Mbit/s` já embute overhead de sincronismo e, no caso PCM30, de sinalização.
- Isso ajuda a mostrar a diferença entre taxa de linha e taxa útil de tráfego.

## Slide 9 — Estrutura do quadro E1

- Em PCM31, quase todos os timeslots podem ser usados como tráfego; em PCM30, perde-se um timeslot para CAS em `TS16`.
- Na prática de dados, muitas vezes o aluno pensa no E1 como “apenas serial síncrona a 2 Mb/s”; este slide recoloca a noção de quadro e canalização.

## Slide 10 — TS0: alternância FAS / NFAS

- O padrão FAS ocupa os bits 2 a 8 do `TS0`; o primeiro bit fica reservado para outros usos, como CRC-4.
- A alternância FAS/NFAS é um mecanismo barato e robusto para evitar sincronismo falso por coincidência nos dados.
- Em G.704, o `TS0` também carrega indicações auxiliares, como RAI, dependendo do modo de operação.

## Slide 11 — Máquina de estados do `E1Unframer`

- A máquina de estados implementa um teste estatístico simples: encontrar o padrão uma vez não basta, é preciso verificar coerência temporal entre quadros pares e ímpares.
- Esse raciocínio é útil para reforçar a ideia de que sincronismo é uma hipótese que precisa ser confirmada continuamente, não um evento único.

## Slide 12 — TS16 e a multitrama de sinalização

- A multitrama CAS de 16 quadros dura `2 ms`, o que já é muito rápido para supervisionar estados telefônicos lentos, como tomada, atendimento e liberação.
- O pulso decádico não é transportado “como áudio”: ele é detectado localmente e convertido em estados de sinalização.
- Esse slide ajuda a separar voz codificada de supervisão do tronco.

## Slide 13 — Alarmes em E1

- `RAI` indica à ponta remota que o receptor detectou falha significativa; `AIS` injeta um padrão que mantém a cadeia de regeneração ativa.
- Em operação real, alarmes permitem localizar falhas sem confundir perda de tráfego com perda de clock ou de enquadramento.
- A prática simplifica isso ao focar em FAS/NFAS, mas o panorama real do E1 inclui uma taxonomia de alarmes mais rica.

## Slide 14 — CRC-4 no E1

- O `CRC-4` é apresentado como reforço posterior ao sincronismo por `FAS/NFAS`, mas o foco principal do slide é a estrutura mostrada na tabela.
- A leitura da tabela deve destacar quatro ideias: `16` quadros por multiframe CRC-4, `8` quadros por `SMF`, `C1..C4` transportados na `SMF` seguinte, e necessidade de agrupar duas `SMFs` para abrir espaço ao alinhamento externo e aos bits `E`.
- A nuance temporal mais importante é que o bloco observado e o bloco que carrega `C1..C4` não são o mesmo. Os `C1..C4` de uma SMF carregam o CRC da `SMF` anterior.
- Os bits C1..C4 enviados no primeiro SMF de um multiframe correspondem ao CRC-4 calculado sobre o segundo SMF do multiframe anterior; a transmissão do CRC sempre se refere ao SMF imediatamente anterior no tempo.
- Ao calcular o CRC-4 de uma `SMF`, os campos `C1..C4` dessa `SMF` entram zerados. O cálculo do CRC-4 não é encadeado.
- A síntese conceitual do slide é: a `SMF` basta para o bloco de CRC, mas o multiframe de `16` quadros continua necessário para o alinhamento externo.

## Slide 15 — Interface física E1 segundo G.703

- O padrão não define apenas bits e taxa, mas também impedância, máscara de pulso, temporização e limites de jitter.
- Em bancada curta, cabos CAT5 costumam funcionar por proximidade de impedância com a interface balanceada de 120 ohms, mas isso não substitui conformidade de campo.
- A presença de acoplamento por transformador ajuda a explicar por que códigos sem componente DC são tão valiosos.

## Slide 16 — Requisitos de um bom código de linha

- Os requisitos elétricos e de sincronismo entram em tensão entre si: mais transições ajudam no clock, mas normalmente aumentam ocupação espectral.
- HDB3 é uma resposta de engenharia para um caso específico: taxa fixa, enlace metálico, acoplamento por transformador e necessidade de regeneração confiável.

## Slide 17 — Panorama visual dos códigos de linha

- Mostrar várias codificações para a mesma sequência binária ajuda a quebrar a intuição ingênua de que “bit 1 é nível alto e bit 0 é nível baixo”.
- O essencial aqui é que código de linha é uma convenção física, não uma propriedade intrínseca do dado binário.

## Slide 18 — NRZ e RZ: os pontos de partida

- `NRZ` é didaticamente simples, mas é péssimo quando precisamos garantir transições ou limitar DC.
- `RZ` facilita temporização, porém cobra o preço em banda e, dependendo da implementação, em potência e complexidade.
- Esses códigos servem bem como referência para justificar escolhas mais elaboradas depois.

## Slide 19 — AMI: o ancestral direto do HDB3

- Em AMI, os `1`s alternam polaridade e os `0`s são ausência de pulso, o que elimina DC para tráfego balanceado e permite detectar violações.
- O ponto fraco estrutural é a sequência longa de zeros, porque ela reduz drasticamente a informação de temporização.
- HDB3 herda quase tudo que AMI faz de bom e corrige exatamente esse ponto.

## Slide 20 — Manchester, Miller e CMI: comparação breve

- Manchester garante transição por bit e é excelente para recuperação de clock, mas consome mais largura de banda.
- Miller e CMI aparecem bem em comparações históricas porque mostram que “resolver clock” pode ser feito de vários jeitos, com custos diferentes.
- É útil destacar que o E1 não precisava da robustez de Manchester ao preço espectral que ele impõe.

## Slide 21 — HDB3: a ideia em uma frase

- HDB3 é AMI com substituição controlada de `0000`, preservando média próxima de zero e inserindo informação de temporização.
- A palavra “controlada” é central: a substituição não é arbitrária; ela segue regras que permitem reconstrução inequívoca no receptor.

## Slide 22 — HDB3: regras `000V` e `B00V`

- `V` cria uma violação intencional da alternância AMI, e por isso é detectável.
- `B` é inserido apenas quando necessário para manter o balanço de polaridade ao longo do tempo.
- A lógica “paridade desde a última violação” é a peça que preserva o baixo conteúdo DC do código.

## Slide 23 — HDB3 em exemplos concretos

- Os exemplos valem mais que a regra abstrata porque deixam visível quando basta `000V` e quando o sistema precisa de `B00V`.
- Uma boa leitura em aula é sempre perguntar primeiro “o que aconteceria em AMI puro?” e só depois mostrar a substituição HDB3.

## Slide 24 — Como o receptor desfaz HDB3

- O receptor não precisa “adivinhar” zeros: ele detecta padrões impossíveis em AMI puro e os mapeia de volta para `0000`.
- O uso de pequeno `look-ahead` em FIFOs mostra bem o compromisso entre implementação simples e necessidade local de contexto.
- Este é um bom slide para ligar teoria de código de linha a arquitetura de hardware.

## Slide 25 — Densidade espectral dos códigos de linha

- O nulo em DC de AMI/HDB3 combina diretamente com acoplamento por transformador e com menor sensibilidade a deriva de linha de base.
- A comparação espectral ajuda a justificar por que “mais transições” não é o único critério relevante.

## Slide 26 — Por que o E1 escolheu HDB3

- A escolha do HDB3 é coerente com o conjunto completo de requisitos do E1: temporização, espectro, simplicidade de regeneração e acoplamento AC.
- Em outras palavras, o HDB3 não é “o melhor código em geral”; é o melhor compromisso para esse tipo de enlace.

## Slide 27 — Hardware da prática: recepção e transmissão E1

- O front-end da prática foi simplificado para cabos curtos, com ênfase didática em tornar observáveis os conceitos de recepção ternária e temporização.
- No transmissor, a FPGA não “gera um pulso analógico ideal”; ela força estados elétricos suficientes para a bancada funcionar de forma previsível.
- Em termos de arquitetura, a placa da prática fica muito mais perto de “transformador + comparadores + lógica digital explícita” do que de um LIU comercial integrado.
- Isso é intencional: em um LIU real, muito do que o aluno precisaria entender fica encapsulado em blocos como `receive equalizer`, `data slicer`, `CDR`, `jitter attenuator`, `line build-out` e detectores de LOS/AIS.

## Slide 28 — Receptor de laboratório vs. receptor comercial

- Em um LIU comercial, equalização, CDR, atenuação de jitter e adaptação de linha já vêm prontos em silício dedicado.
- A prática abre essa caixa-preta para o aluno enxergar explicitamente onde nascem as decisões de relógio e símbolo.
- Vale insistir em uma nuance importante: nem todo LIU comercial usa um “equalizador adaptativo estilo modem” com muitos taps e algoritmo complexo. Em muitas famílias, há uma mistura de filtro analógico, seleção de modo `short-haul/long-haul`, `slicer` programável e CDR integrado.
- Exemplo clássico: o Infineon `PEB2255` (`FALC-LH`) descreve uma interface `short-haul/long-haul` com “receive equalization network and noise filtering”; em `short haul` o alcance especificado é até cerca de `-10 dB`, e em `long haul`, com `EQON=1`, a recuperação chega a cerca de `-43 dB` de atenuação de cabo. O dado recebido é `peak detected` e fatiado em cerca de `55%` do pico antes de seguir para o CDR.
- Exemplo de AFE configurável de geração seguinte: o `IDT82V2052E` / `Renesas 82V2052E` integra equalizador adaptativo, `data slicer`, CDR, decodificação AMI/HDB3 e jitter attenuator. Em `host mode`, o equalizador pode ser ativado ou desativado por registrador (`EQ_ON`); com isso, a sensibilidade de recepção sai de cerca de `-10 dB` para `-20 dB`, e o limiar de LOS também passa a ser programável.
- O mesmo `82V2052E` deixa explícito que o `slicer` não é fixo: o limiar pode ser configurado para `40%`, `50%`, `60%` ou `70%`, e o CDR pode até ser contornado em certos modos. Isso é um bom contraexemplo à ideia de que “receptor comercial = caixa preta monolítica sem parametrização”.
- Exemplo ainda mais explícito de recepção com mais observabilidade: o Zarlink/Microchip `MT9076B` anuncia `automatic or manual receiver equalization` e informa a amplitude de pico recebida com resolução de 8 bits. Esse tipo de chip já fica mais próximo de um front-end com realimentação e telemetria de linha.
- Exemplo de LIU/transceiver bastante integrado: o `DS2148` da Dallas/Maxim (hoje Analog Devices) suporta `short-haul` e `long-haul`, seleção de terminação `75/100/120 ohms`, `jitter attenuator` interno de 32 ou 128 bits, `line build-out` e ajuste automático de sensibilidade. Aqui a leitura correta é “AFE e recuperação integrados e configuráveis”, não necessariamente “DSP sofisticado de equalização adaptativa”.
- Outro exemplo histórico útil é o `PM4351 COMET`, que integra framer E1/T1/J1 com LIU, equalização de recepção, clock recovery, monitoramento de linha e atenuação de jitter em transmissão e recepção. Ele mostra como o mercado frequentemente vendia a solução como um único transceiver, não como blocos separados.

## Slide 29 — Detectar um pulso recebido: problema de decisão

- O problema abstrato continua sendo decidir entre hipóteses na presença de ruído, distorção e incerteza temporal.
- Em bancada, os comparadores já fazem uma parte dessa decisão, reduzindo o problema para três estados lógicos observáveis.
- Isso permite focar na cadeia digital sem fingir que o problema analógico não existe.
- Em um LIU real, a sequência típica é algo como: transformador e terminação -> compensação/equalização -> medição de amplitude ou pico -> `slicer` -> CDR -> decodificador de linha. A diferença para a prática é que aqui várias dessas etapas foram deliberadamente “achatadas” em dois comparadores.
- Essa decomposição também ajuda a explicar por que o `slicer` é um bloco distinto do CDR: primeiro é preciso decidir se houve pulso e com que polaridade; depois é preciso alinhar no tempo a leitura desses eventos.

## Slide 30 — Por que na Prática 2 um limiar simples basta

- A simplificação do limiar é uma escolha pedagógica e experimental: cabo curto, baixa atenuação e ambiente controlado.
- Em um enlace real mais longo, limiar fixo pode falhar por ruído, atenuação dependente de frequência, dispersão e jitter.
- Em bancada curta, o transformador e os comparadores já entregam algo muito próximo de uma decisão ternária útil. Em outras palavras, o laboratório “compra” simplicidade abrindo mão de alcance e robustez de interoperabilidade.
- Em produtos reais, é comum ver combinadas três camadas de robustez que a prática não implementa: seleção de perfil de linha (`short-haul`/`long-haul`), limiar/slicer configurável e alguma forma de equalização automática ou semi-automática.
- Uma formulação pedagógica segura é: “o front-end comercial normalmente combina compensação analógica de linha, decisão por limiar e recuperação de clock; isso não implica necessariamente um equalizador adaptativo complexo de estilo modem”.

## Slide 31 — Recuperação de temporização: o problema central

- Mesmo pequenos desvios de frequência acumulam erro de fase ao longo do tempo.
- O problema central não é “quando chega o próximo bit em média”, mas “onde está o melhor ponto de amostragem agora”.
- É esse erro acumulado que a DPLL precisa manter confinado.
- Em chips comerciais, a recuperação de relógio costuma estar acoplada ao `slicer` e ao detector de LOS. O `82V2052E`, por exemplo, explicita que o relógio recuperado acompanha o jitter dos dados vindos do `slicer` e mantém a relação de fase mesmo durante ausências temporárias de pulso.

## Slide 32 — DPLL da Prática 2: funcionamento

- A DPLL da prática é intencionalmente discreta e simples: ela usa um erro quantizado em `{-1, 0, +1}` para corrigir o próximo período.
- Essa implementação já basta para mostrar os blocos conceituais de um laço de recuperação de clock: detector de fase, referência local e ajuste do oscilador numérico.

## Slide 33 — Interpretação em blocos: detector de fase + NCO

- Chamar o contador ajustável de `NCO` ajuda a conectar a prática à terminologia clássica de PLLs digitais.
- O detector de fase aqui não mede fase contínua; ele classifica a borda em cedo/no tempo/tarde, o que simplifica muito o hardware.

## Slide 34 — Por que o laço converge

- A convergência vem do fato de a correção atuar no sentido oposto ao erro medido, configurando realimentação negativa.
- O regime travado não significa erro zero absoluto, mas erro limitado por quantização temporal e pelo espaçamento entre transições úteis.

## Slide 35 — Oversampling: o que ele proporciona

- Aumentar o oversampling melhora a resolução temporal do detector de fase e reduz o erro residual.
- O preço é consumo de clock interno, contadores maiores e, possivelmente, maior custo de implementação.
- É útil distinguir conforto de projeto de mínimo teórico viável.

## Slide 36 — Limites teóricos desta DPLL em HDB3

- A pior condição para correção ocorre quando o código de linha passa o maior intervalo possível sem transição observável.
- No HDB3, esse intervalo é limitado, e essa limitação é justamente o elo entre código de linha e clock recovery.
- A fórmula aproximada mostra dependência direta do oversampling `M` e do espaçamento máximo entre transições `K`.

## Slide 37 — Diagrama de olho aplicado ao E1

- O diagrama de olho condensa, em uma única visualização, os efeitos combinados de ruído, ISI e jitter.
- Verticalmente, ele fala de margem de decisão; horizontalmente, de margem temporal.
- Isso torna intuitiva a função da DPLL: manter a amostragem onde o “olho” está mais aberto.

## Slide 38 — Comutação por circuitos vs. comutação por pacotes

- O E1 nasce do mundo de circuitos reservados no tempo, enquanto o IP assume multiplexação estatística de pacotes.
- A prática é interessante justamente porque sobrepõe as duas lógicas: pacotes IP sendo transportados sobre uma infraestrutura herdada da telefonia digital.

## Slide 39 — HDLC: papel na cadeia

- Depois de recuperar bits e escolher timeslots, ainda falta delimitar começo e fim do quadro de enlace.
- Em enlaces síncronos, HDLC resolve isso com uma flag explícita e transparência bit a bit.
- A presença de flags contínuas em ociosidade também ajuda a manter o receptor alinhado em nível de enquadramento HDLC.

## Slide 40 — Bit stuffing: transparência orientada a bit

- O bit stuffing impede que o padrão de flag `01111110` apareça acidentalmente no conteúdo.
- O detalhe importante é que a inserção acontece após cinco `1`s consecutivos, inclusive quando essa sequência cruza partes internas do quadro.
- No receptor, a remoção do bit inserido deve acontecer antes da verificação do FCS.

## Slide 41 — Da flag ao ping

- O fluxo recebido pela FPGA não é “HDLC puro” até a aplicação: ele ainda carrega um quadro cHDLC com um datagrama IPv4 e um pacote ICMP.
- O `ICMPReplier` é um exemplo mínimo de processamento de protocolo: reconhece tipo, troca endereços e atualiza checksums/FCS.
- Isso mostra como camadas superiores dependem diretamente de uma base física e de enlace corretamente recuperada.

## Slide 42 — Detecção de erros: por que o CRC

- O ganho do CRC vem de combinar baixo custo de implementação com garantias matemáticas fortes para classes importantes de erro.
- Representar bits como polinômio em `GF(2)` elimina carries e torna a álgebra compatível com circuitos XOR.

## Slide 43 — GF(2): soma e subtração viram XOR

- Em `GF(2)`, subtração e soma coincidem, por isso a divisão polinomial pode ser implementada com deslocamentos e XORs.
- Esse é o passo conceitual que costuma tornar o CRC “menos mágico” para quem o viu apenas como uma fórmula pronta.

## Slide 44 — Divisão polinomial: passo a passo

- O transmissor escolhe os bits de redundância para que o quadro inteiro seja divisível por `G(x)`.
- O receptor não precisa conhecer o payload original: basta testar se o quadro recebido deixa resto zero ao dividir pelo mesmo gerador.
- Esse raciocínio vale tanto para software quanto para hardware.

## Slide 45 — Por que CRC é amigável para FPGA

- O LFSR materializa a divisão polinomial como um circuito sequencial pequeno e eficiente.
- Cada tap corresponde a um termo do polinômio gerador, o que dá uma ponte direta entre matemática e circuito.
- É um ótimo exemplo de algoritmo cuja formulação algébrica foi praticamente feita para virar hardware.

## Slide 46 — Capacidade de detecção do CRC

- Todo gerador com pelo menos dois termos detecta erros de um bit.
- CRCs bem escolhidos também detectam todos os erros de dois bits até certos comprimentos de quadro e todos os bursts até o grau do polinômio.
- Para além dessas garantias, a escolha do polinômio importa bastante e não deve ser vista como arbitrária.

## Slide 47 — Mapa do quadro E1: voz, sinalização e dados

- É útil distinguir planos: o canal de voz transporta PCM, enquanto `TS16` transporta supervisão CAS do tronco.
- Em troncos digitais entre equipamentos, quem gera e interpreta ABCD é a central ou o PABX, não o telefone analógico do assinante.

## Slide 48 — E&M: sinalização de linha para troncos

- E&M trata supervisão do tronco: livre, tomada, atendimento e desligamento.
- Ele não define o método de envio de dígitos; por isso pode coexistir com DTMF, pulso ou MFC, conforme o cenário.
- Em implementações digitais, os estados acabam mapeados em bits ABCD por timeslot.

## Slide 49 — E&M: caso típico de tie-line entre PABXs

- Em uma `tie-line`, o tronco funciona como uma extensão entre dois sistemas telefônicos, com supervisão simples e encaminhamento remoto dos dígitos.
- O `wink` é um bom exemplo de confirmação curta de prontidão antes do envio da sinalização seguinte.

## Slide 50 — R2/MFC: sinalização em dois planos no mesmo E1

- O R2 separa claramente sinalização de linha e sinalização de registradores, mas ambas coexistem sobre o mesmo circuito lógico.
- A parte compelida do MFC é importante: cada passo depende de resposta explícita do outro lado, o que reduz ambiguidades no estabelecimento da chamada.

## Slide 51 — R2 digital: bits A/B por fase da chamada

- A tabela ajuda a mostrar que os bits ABCD não são “dados” no sentido usual, mas estados de supervisão que evoluem com a chamada.
- No caso internacional clássico, bastam essencialmente os bits A e B para a supervisão principal.

## Slide 52 — R2/MFC: diálogo compelido entre registradores

- O registrador de origem não despeja todos os dígitos de uma vez; ele avança conforme a resposta do destino.
- Essa estrutura dialogada era útil para redes heterogêneas, porque o destino podia pedir mais informação ou mudar de grupo de sinais conforme a rota.

## Slide 53 — DTMF, pulso decádico e MFC: quem é in-band?

- `DTMF` e `MFC` usam banda de voz; pulso decádico nasce como supervisão elétrica do acesso analógico.
- Quando um gateway leva pulso decádico para E1/CAS, ele converte o estado local em bits de sinalização, não em áudio correspondente ao clique do disco.
- Esse slide ajuda a evitar o erro comum de chamar toda discagem de “in-band”.

## Slide 54 — Da telefonia CAS ao SIP: panorama evolutivo

- A história da sinalização pode ser lida como uma migração progressiva para maior separação entre mídia e controle.
- A analogia com SIP é útil como mapa mental, mas não deve ser tomada como equivalência de protocolo; é apenas correspondência funcional aproximada.

## Slide 55 — Conexão com equipamentos de mercado

- Equipamentos reais encapsulam muita complexidade: física E1, enquadramento, CAS/CCS, fracionamento de canais e adaptação para rede de dados ou voz.
- Configurações como `idle`, `seize` e variantes de ABCD costumam depender do fabricante e do perfil de interoperabilidade.

## Slide 56 — BSV: o mínimo para ler a prática

- A meta aqui não é ensinar Bluespec em profundidade, mas dar vocabulário suficiente para o aluno ler os blocos da prática sem se perder.
- Interfaces tipadas ajudam a enxergar o pipeline como composição de blocos com contratos explícitos.

## Slide 57 — BSV: regras, FIFOs e composição

- `rule` em BSV é uma ação reativa com guarda; isso ajuda a modelar hardware concorrente sem escrever sempre controle de baixo nível.
- FIFOs desacoplam estágios e simplificam o raciocínio temporal entre produtor e consumidor.
- `mkConnection` reforça a ideia de que grande parte da prática é composição de blocos bem definidos.

## Slide 58 — Mapa mental para entrar na prática

- O objetivo final do módulo é dar um mapa coerente, não apenas uma lista de tópicos.
- Se o aluno entende como física, temporização, enquadramento, sinalização, CRC e arquitetura em BSV se encadeiam, o restante da prática fica muito mais legível.

## Referências

- TIBBS, John. *Pocket Guide to The world of E1*. 2002. https://web.archive.org/web/20240429125245/https://web.fe.up.pt/~mleitao/STEL/Tecnico/E1_ACTERNA.pdf
- GUIMARÃES, Dayan Adionel. *Digital Transmission*. 2009. https://doi.org/10.1007/978-3-642-01359-1
- EATER, Ben. *How do CRCs work?* 2019. https://youtu.be/izG7qT0EpBw
- SIEMENS. *Treinamento Cisco MC3810V*. 2022. https://telecom.matias.co.in/static/cisco-MC3810V.pdf
- SILVA, Antonino Costa. *Tipos de Sinalização nos Sistemas de Telefonia*. 2024. https://www.slideshare.net/slideshow/sinalizacao-tipos-de-sinalizacao-nos-sistemas-de-telefonia/272583472
- ITU-T G.703, resumo oficial: https://www.itu.int/dms_pubrec/itu-t/rec/g/T-REC-G.703-201604-I%21%21SUM-HTM-E.htm
- ITU-T G.704, estrutura de quadro a 2048 kbit/s e FAS/NFAS em cópia histórica da ITU: https://search.itu.int/history/HistoryDigitalCollectionDocLibrary/4.260.43.en.1014.pdf
- RFC 1662, *PPP in HDLC-like Framing*: https://datatracker.ietf.org/doc/html/rfc1662
- RFC 791, *Internet Protocol*: https://www.rfc-editor.org/rfc/rfc791
- RFC 792, *Internet Control Message Protocol*: https://www.rfc-editor.org/rfc/rfc792
- Cisco, *Understanding How Digital T1 CAS Works in IOS Gateways*: https://www.cisco.com/c/en/us/support/docs/voice/digital-cas/22444-t1-cas-ios.html
- Philip Koopman, *CRC Polynomial Zoo* e material de seleção de CRCs: https://users.ece.cmu.edu/~koopman/crc/
- Infineon. *PEB 2255 FALC-LH V1.3 Data Sheet*. 2000. https://media.digikey.com/pdf/Data%20Sheets/Infineon%20PDFs/PEB%202255.pdf
- Renesas / IDT. *82V2052E Dual Channel E1 Short Haul LIU Data Sheet*. 2005. https://www.renesas.com/en/document/dst/82v2052e-data-sheet
- Analog Devices / Maxim. *DS2148 5V E1/T1/J1 Line Interface*. https://www.analog.com/en/products/ds2148.html
- Microchip / Zarlink. *MT9076B Datasheet*. https://www.digikey.com/en/htmldatasheets/production/1328303/0/0/1/mt9076b.html
- PMC-Sierra. *PM4351 COMET Combined E1/T1 Transceiver*. https://manualmachine.com/datasheet/pm4351/4278925-datasheet-pmc/
