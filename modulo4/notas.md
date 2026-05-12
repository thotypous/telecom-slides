# Notas de apoio — Módulo 4

## Slide 1 — Capa

- O módulo conecta três níveis que muitas vezes são estudados separadamente: a física da radiação eletromagnética, a prática de projetar e medir antenas, e o uso real de enlaces de rádio em sistemas de radioamador e satélite.
- A frase “da teoria de antenas ao enlace com satélites” deve ser lida literalmente. Começaremos com Maxwell, impedância, radiação e diretividade; depois passaremos por simulação e medida; e finalmente usaremos esses conceitos para fechar um enlace com a ISS ou com satélites de radioamador.
- O radioamadorismo entra como ambiente experimental legalmente estruturado. Ele permite operar transmissores, antenas e modos digitais em faixas definidas, com identificação, limites técnicos e responsabilidade do operador. Isso é diferente de simplesmente ligar qualquer transmissor em qualquer frequência.

## Slide 2 — Objetivos deste módulo

- O primeiro objetivo é separar três regimes práticos: operar como radioamador licenciado, operar uma estação de radioamador sob supervisão de alguém licenciado e usar equipamentos de radiação restrita/ISM homologados sem COER próprio. `ISM` significa aplicações industriais, científicas e médicas; `COER` é o Certificado de Operador de Estação de Radioamador.
- O segundo objetivo é evitar que antena seja tratada como “acessório mágico”. Uma antena é o elemento que transforma corrente e tensão em campo eletromagnético radiado; por isso impedância, casamento, polarização, ganho e diagrama de radiação afetam diretamente o enlace.
- A parte de simulação não substitui medida. `NEC` é o Numerical Electromagnetics Code; `MoM` é o Método dos Momentos; `FDTD` é Finite-Difference Time-Domain, isto é, diferenças finitas no domínio do tempo. Essas técnicas ajudam a prever comportamento, mas o NanoVNA mostra o que a antena real, construída com materiais reais, conectores reais e proximidade de objetos reais, está fazendo.
- O link budget, ou orçamento de enlace, fecha o ciclo: potência, perdas, ganho de antenas, distância, ruído e margem deixam de ser conceitos isolados e viram uma conta de viabilidade de comunicação.
- `APRS` é o Automatic Packet Reporting System, usado para telemetria, posição e mensagens curtas; `AX.25` é o protocolo de enlace de pacotes usado historicamente em rádio amador; `IL2P` é o Improved Layer 2 Protocol, uma alternativa moderna ao AX.25. Eles aparecem porque enlaces reais não terminam na RF. Depois que a portadora chega ao receptor, ainda precisamos enquadrar bits, detectar erros e, em alguns casos, corrigi-los.

## Slide 3 — Radioamadorismo

- Radioamadorismo é um serviço de radiocomunicações, não apenas um hobby informal. A finalidade é autoformação, intercomunicação entre radioamadores, investigação técnica e apoio em emergências, sem exploração comercial do canal.
- No Brasil, a autoridade regulatória é a Anatel. A Anatel define requisitos de habilitação, licenciamento, indicativos, faixas, potências, modos e responsabilidades. A LABRE não substitui a Anatel e não emite autorização estatal para operar.
- A `LABRE` é a Liga de Amadores Brasileiros de Rádio Emissão, sociedade-membro brasileira da `IARU`, a International Amateur Radio Union. Isso significa que, no ecossistema internacional do radioamadorismo, ela é a entidade nacional reconhecida como representante da comunidade brasileira de radioamadores junto à IARU. Associar-se à LABRE pode trazer benefícios associativos, representação e serviços comunitários, mas não é requisito para obter COER nem para operar uma estação licenciada.
- A IARU não é uma agência da ONU. Ela é uma união internacional de associações de radioamadores. A relação com o sistema internacional vem de sua atuação junto à `UIT`/`ITU`, a União Internacional de Telecomunicações: a IARU participa como membro setorial e contribui tecnicamente nos trabalhos da UIT-R, o setor de radiocomunicações da UIT, mas quem vota nas conferências da UIT são as administrações nacionais dos Estados-membros, como o Brasil por meio de seus órgãos competentes.
- A consequência prática é esta: a IARU influencia e coordena planos de banda e defesa de espectro, a LABRE participa como sociedade nacional, mas a regra juridicamente aplicável no Brasil é a norma brasileira da Anatel.
- `DX` significa comunicação a longa distância. Em HF, DX costuma depender fortemente de propagação ionosférica, ciclo solar, horário, estação do ano, ruído e escolha da banda. Em VHF/UHF, DX pode envolver tropoduto, esporádica-E, reflexão lunar, satélites, meteor scatter ou outras condições especiais.
- A motivação de engenharia é que radioamadorismo transforma RF em laboratório acessível: pode-se estudar antenas, propagação, ruído, filtros, modos digitais, satélites e protocolos com sinais reais e com responsabilidade regulatória clara.

## Slide 4 — Como se tornar radioamador no Brasil

- O COER é o certificado de operador. Ele comprova que a pessoa foi aprovada nos exames exigidos para uma classe, mas a operação regular também depende da licença/autorização da estação quando aplicável.
- O processo envolve sistemas da Anatel, prova eletrônica e regras de aplicação. O detalhe operacional muda com atos e procedimentos administrativos, por isso o slide aponta para a norma e para a cartilha oficial em vez de tentar transformar o fluxo em uma receita permanente.
- As provas cobrem três dimensões: legislação, técnica/ética operacional e eletrônica/eletricidade. Isso reflete a natureza do serviço: não basta “saber falar no rádio”; é preciso conhecer limites de faixa, identificação, interferência, potência, boas práticas e fundamentos técnicos.
- O indicativo de chamada é parte central da operação. Ele identifica a estação e deve ser usado conforme as regras operacionais. Em rádio, identificação não é detalhe burocrático: ela permite responsabilização, coordenação e convivência entre usuários do espectro.
- A progressão de classe amplia privilégios, mas não elimina responsabilidades. Operadores de classes superiores podem acessar mais faixas e maiores potências, porém continuam sujeitos ao uso da potência mínima necessária, aos modos permitidos e às regras de convivência.

## Slide 5 — Classes: privilégios e progressão

- As classes A, B e C não representam “qualidade” do radioamador; representam conjuntos diferentes de habilitação e privilégios. A classe define quais faixas podem ser usadas e qual potência máxima geral pode ser aplicada, salvo limites específicos por subfaixa.
- A potência da tabela é potência média na saída do transmissor, não potência recebida, nem potência radiada. Quando a norma fala em `PIRE`/`e.i.r.p.`, isto é, potência isotrópica radiada equivalente, o ganho da antena entra na conta. Por isso uma estação com transmissor modesto e antena direcional pode ter PIRE alta.
- A frase “radioamadores podem operar equipamento de fabricação própria” deve ser entendida dentro do `SRA`, o Serviço de Radioamador, mas não elimina a exigência brasileira de certificação/homologação para emissores de `RF`, isto é, radiofrequência. A `LGT`, Lei Geral de Telecomunicações, veda o uso de equipamento emissor de radiofrequência sem certificação expedida ou aceita pela Anatel.
- Para construção artesanal ou produto importado para uso próprio, a Resolução 715/2019 prevê o caminho de declaração de conformidade. Esse caminho é diferente da homologação comercial de um rádio vendido em escala, mas ainda é uma forma de regularizar o equipamento perante a Anatel.
- Portanto, não é correto resumir como “sou radioamador, construí, posso simplesmente transmitir”. O operador precisa estar habilitado, a estação precisa estar autorizada quando aplicável, a emissão precisa obedecer faixas, modos, potência, pureza espectral e identificação, e o emissor precisa estar regularizado conforme o procedimento aplicável.
- Isso também não transforma o equipamento artesanal em produto homologado para venda ou uso geral. Se ele for comercializado ou usado fora do SRA, por exemplo como dispositivo de radiação restrita/ISM, passa a valer o enquadramento próprio daquele tipo de equipamento. Na prática, fazer isso com hardware caseiro costuma exigir ensaios laboratoriais caros; por isso, para projetos de disciplina sem COER, o caminho pragmático é usar módulos já homologados e respeitar exatamente as condições de uso.
- A classe não dá permissão para ignorar a destinação da faixa. Um operador Classe A tem mais acesso a HF, mas não pode usar uma faixa de serviço aeronáutico, celular ou radiodifusão só porque sabe operar rádio.

## Slide 6 — Operar sem COER próprio

- Há duas situações muito diferentes: operar uma estação de radioamador sob supervisão e operar equipamento de radiação restrita sem estar no Serviço de Radioamador.
- Sob supervisão, a estação continua sendo de radioamador. A operação fica limitada pela classe e pela licença do responsável, e o responsável continua respondendo por identificação, ética, faixa, potência, modo e interferência. O terceiro sem COER não “ganha” uma licença própria; ele opera dentro da estação e sob responsabilidade do titular habilitado.
- Sem supervisão, a alternativa usual em projetos de IoT é usar equipamentos de radiação restrita homologados. Esses equipamentos não têm direito à proteção contra interferência prejudicial e não podem causar interferência a sistemas autorizados. Se causarem interferência, devem cessar a operação até a causa ser removida.
- `ISM` não é sinônimo de “faixa livre”. ISM designa faixas associadas a aplicações industriais, científicas e médicas em regulamentos de radiocomunicação; radiação restrita é o enquadramento brasileiro para equipamentos de baixa potência que operam sem licença individual, sem proteção contra interferência e sob requisitos técnicos específicos. Wi-Fi, `BLE` (Bluetooth Low Energy), `RFID` (identificação por radiofrequência), LoRa e módulos similares costumam ser tratados na prática pelos requisitos de radiação restrita da Anatel, mesmo quando o mercado chama a faixa de “ISM”.
- O rótulo comercial “ISM” não dispensa homologação nem limites de potência, antena, faixa e aplicação. A pergunta correta não é apenas “a frequência é ISM?”, mas “este equipamento homologado pode operar nesta subfaixa, com esta potência, esta antena, este modo e esta aplicação?”.
- 433 MHz e 915 MHz não são equivalentes no Brasil. A região de 433 MHz coincide com a banda de 70 cm do Serviço de Radioamador e, na Região 2 da UIT, não é a faixa ISM genérica usada na Europa. No Ato 14448/2017, a janela `433,5-434,5 MHz` aparece em requisitos para RFID e aplicações similares, não como autorização geral para qualquer telemetria LoRa ou modulação digital espalhada.
- Já `902-907,5 MHz` e `915-928 MHz` aparecem nos requisitos brasileiros de radiação restrita para espalhamento espectral e outras tecnologias de modulação digital, além de também aparecerem no plano do radioamador em 33 cm. A legalidade depende do serviço/enquadramento, do equipamento homologado, da potência, da antena, do duty cycle, da aplicação e da subfaixa exata.
- Para um balão estratosférico sem COER, não basta perguntar “433 ou 915?”. Se o transmissor for parte de uma estação `NSS`, Near Space Station, a norma do Serviço de Radioamador trata estações de alta altitude dentro da atmosfera e exige operador/estação dentro do SRA. Sem isso, o caminho teria que ser radiação restrita com equipamento homologado e condições de uso compatíveis com a aplicação. Um módulo LoRa homologado para uso geral em solo não deve ser presumido automaticamente válido para qualquer perfil de operação em balão, antena, altitude e duty cycle.
- Em 433 MHz, há risco adicional de confusão com subfaixas de radioamador e com usos específicos do plano de 70 cm. Um payload transmitindo autonomamente em 433 MHz pode facilmente cair em uma aplicação que exige coordenação e habilitação se for tratado como radioamador, ou violar as condições de radiação restrita se for tratado como dispositivo comum. Além disso, o Ato 926/2024 não permite salto em frequência nem espalhamento espectral em faixas de radioamador abaixo de 440 MHz.
- Em 915 MHz, a faixa é mais comum para `LoRaWAN`, isto é, uma rede de baixa potência e longo alcance construída sobre a modulação LoRa, e para telemetria de baixa potência no Brasil. Mas continua valendo a regra: equipamento homologado, antena dentro do permitido no certificado/manual, limites técnicos atendidos e ausência de interferência prejudicial. “É 915 MHz” não é autorização genérica.
- Antena faz parte do sistema irradiante. Em radiação restrita, a Resolução 680 estabelece a ideia geral de que o equipamento deve ser projetado para usar apenas a antena comercializada com ele, exceto condições específicas previstas nos requisitos técnicos de certificação. Portanto, trocar a antena pode alterar a conformidade.
- Em termos práticos, ligar uma antena externa em Wi-Fi, BLE ou LoRa homologado só é uma aposta segura quando a antena, o conector, o ganho, a faixa, a configuração de potência e o modo de instalação estão contemplados pela homologação ou pelo manual/certificado do produto. Se a homologação foi obtida com antena integrada ou com uma lista específica de antenas, substituir por uma Yagi, painel, colinear ou antena de maior ganho pode descaracterizar a certificação do conjunto.
- Mesmo quando o rádio reduz potência automaticamente, o limite regulatório muitas vezes é expresso em e.i.r.p./PIRE ou densidade espectral radiada. A antena de maior ganho pode tornar ilegal um transmissor que, na bancada com antena original, estava dentro do limite.
- Para projetos didáticos sem COER, a regra de engenharia responsável é: usar módulo homologado no Brasil, não alterar antena fora do previsto, não aumentar potência, limitar duty cycle, manter documentação do certificado e escolher uma frequência/subfaixa adequada ao uso pretendido.

## Slide 7 — Indicativos e regiões

- O indicativo é o nome público da estação no ar. Ele não é apelido nem login: é uma identificação regulatória, formada a partir de séries internacionais atribuídas ao Brasil e de regras nacionais de prefixo, algarismo e sufixo.
- As séries internacionais do Brasil incluem blocos como `PP` a `PY` e `ZV` a `ZZ`. A Anatel distribui indicativos efetivos e especiais dentro dessas possibilidades, considerando UF, classe, tipo de estação e disponibilidade.
- O algarismo do indicativo normalmente identifica região/UF no plano brasileiro. Por isso `PY2...` sugere São Paulo/Goiás/Tocantins/DF conforme a tabela do slide, enquanto `PY3...` remete ao Rio Grande do Sul.
- Indicativos de Classe C usam, em geral, prefixo `PU` e sufixo de três letras. Classes A e B têm outras faixas de prefixos e podem usar sufixos de duas ou três letras conforme disponibilidade e regra aplicável.
- Indicativos especiais existem para eventos, concursos, ativações e situações temporárias. Eles não substituem o indicativo efetivo como identidade permanente da estação.
- A identificação correta ajuda a manter o serviço auditável. Em uma rede de repetidora, satélite ou APRS, o indicativo permite saber quem transmitiu, de onde, em qual contexto e sob qual autorização.
- As sequências proibidas no sufixo evitam confusão com sinais de perigo, códigos operacionais e séries reservadas, como `SOS`, `PAN`, `RRR` e a série `QAA` a `QZZ`.

## Slide 8 — Plano de bandas brasileiro: visão geral

- O plano de bandas não é apenas uma lista de frequências. Ele organiza convivência: quais classes podem usar cada faixa, quais modos são previstos, quais aplicações são prioritárias ou exclusivas e quais limites de potência se aplicam.
- Em HF, a propagação domina a experiência. Bandas baixas, como 160 m e 80 m, favorecem propagação noturna e exigem antenas fisicamente grandes. Bandas como 20 m, 17 m, 15 m, 12 m e 10 m dependem fortemente da ionosfera e do ciclo solar para DX.
- `NVIS` é Near Vertical Incidence Skywave, ou propagação quase vertical pela ionosfera. Ela é útil para comunicação regional em HF quando se quer cobrir centenas de quilômetros sem depender de repetidoras. Por isso 40 m e 60 m aparecem com comentários regionais.
- Em VHF/UHF, a comunicação tende a ser mais local e por linha de visada, mas isso não significa “curto alcance sempre”. Repetidoras, satélites, antenas direcionais, elevação, ductos troposféricos e modos fracos podem ampliar muito o alcance.
- A banda de 2 m é central para este módulo porque combina equipamentos acessíveis, antenas de tamanho manejável e aplicações reais como repetidoras, APRS e satélites, incluindo a ISS em 145,825 MHz.
- A banda de 70 cm é igualmente importante para satélites e experimentação com antenas, mas o efeito Doppler é mais visível. Isso prepara a discussão posterior de enlaces LEO.
- A tabela é uma visão geral. Para operação real, o Ato Anatel 926/2024 deve ser consultado porque subfaixas específicas podem ter modos, aplicações e exclusividades que não cabem no slide.

## Slide 9 — Banda de 2 m em detalhe

- A banda de 2 m vai de 144 a 148 MHz no Brasil e é uma das faixas mais usadas por radioamadores iniciantes e por projetos educacionais. O comprimento de onda de cerca de 2 m permite antenas portáteis: um quarto de onda tem aproximadamente 50 cm antes de ajustes práticos.
- O slide destaca que a mesma banda contém usos muito diferentes: `CW` (telegrafia em onda contínua), `SSB` (fonia em banda lateral única), modos digitais, repetidoras, ACDS/IVG, APRS terrestre, chamada FM, satélites e entradas/saídas de repetidoras.
- `ACDS` significa Automatic Controlled Data Stations, isto é, estações de operação automática em modos digitais. No plano de bandas, indica subfaixas destinadas a estações digitais automáticas, como nós, gateways ou sistemas de pacote que podem transmitir sem intervenção manual a cada quadro.
- `IVG` significa Internet Voice Gateway, ou gateway de voz via internet. É a aplicação em que uma estação de rádio interliga voz em RF a uma rede pela internet, como nós Echolink/IRLP e sistemas equivalentes; por isso o plano reserva subfaixas específicas para evitar mistura desordenada com chamada, satélite, repetidoras e operação ponto a ponto.
- Repetidoras usam pares de frequência: uma frequência de entrada, recebida pela repetidora, e uma frequência de saída, transmitida pela repetidora. Em 2 m, o offset típico é 600 kHz, mas o sentido do par depende da subfaixa.
- A frequência nacional de chamada FM, 146,520 MHz, não é “frequência para conversar indefinidamente”. A boa prática é chamar, estabelecer contato e migrar para outra frequência livre quando apropriado.
- APRS terrestre no Brasil aparece em 145,570 MHz na tabela do slide. APRS via ISS usa 145,825 MHz e exige janela de passagem, antena adequada, Doppler pequeno o suficiente para FM, formato AX.25/APRS correto e respeito ao uso compartilhado do canal.
- A subfaixa 145,800 a 146,000 MHz é indicada como satélite exclusivo. Isso é importante porque satélites têm footprint continental: uma transmissão local pode interferir em usuários a milhares de quilômetros se cair na janela de satélite.
- Para a prática com Yagi em 145,8 MHz, a banda de 2 m é conveniente porque a antena ainda é grande o suficiente para mostrar geometria claramente, mas pequena o bastante para ser construída, medida e apontada manualmente.

## Slide 10 — Banda de 70 cm em detalhe

- A banda de 70 cm vai de 430 a 440 MHz no Brasil. O comprimento de onda menor permite antenas muito compactas: um elemento de meia onda tem ordem de 34 cm, o que torna Yagis de bancada bastante viáveis.
- A janela de satélites em 435 a 438 MHz é maior que a janela satelital em 2 m. Muitos cubesats usam 70 cm porque antenas pequenas cabem melhor no satélite e porque há espaço prático para diferentes modos e canais.
- O efeito Doppler cresce proporcionalmente à frequência. Para um satélite `LEO`, Low Earth Orbit ou órbita baixa da Terra, a cerca de 7,5 km/s, o deslocamento máximo aproximado é `f * v/c`. Em 437 MHz isso dá cerca de 11 kHz; em 145 MHz dá cerca de 3,6 kHz. Por isso 70 cm exige mais atenção de sintonia, principalmente em SSB, CW e modos digitais estreitos.
- Em FM larga, parte do Doppler pode caber dentro da largura de canal, mas isso não significa que ele desapareça. Em satélites FM de 70 cm, operadores frequentemente corrigem a frequência em passos durante a passagem.
- Repetidoras de 70 cm usam deslocamento típico de 5 MHz, com entradas e saídas em subfaixas separadas. Confundir entrada e saída faz o operador transmitir onde deveria apenas escutar, ou escutar onde ninguém transmitirá para usuários finais.
- A proximidade entre 433 MHz como região popular de módulos de curto alcance e a banda de radioamador de 70 cm exige cuidado regulatório. Um módulo “433 MHz” não está automaticamente autorizado para qualquer uso, potência, antena ou aplicação só porque existem dispositivos comerciais nessa faixa.
- Módulos LoRa vendidos como “EU433” ou para a Região 1 precisam de atenção especial. Eles podem estar configurados para planos de canal, potência e premissas regulatórias europeias que não correspondem ao enquadramento brasileiro; em especial, `433 MHz` não deve ser tratado como equivalente nacional às faixas brasileiras de modulação digital de radiação restrita.
- O mesmo alerta vale para módulos `868 MHz`: essa faixa é comum em produtos europeus, mas não é a faixa brasileira típica para LoRaWAN/radiação restrita. Para projetos no Brasil, o caminho usual é usar módulos homologados e planos compatíveis com `915-928 MHz`, como perfis `AU915`/`US915` quando aplicáveis ao produto e à rede.
- Para antenas, 70 cm é excelente para demonstrar diretividade. Pequenas mudanças de comprimento, espaçamento, conector, cabo e proximidade da mão já alteram impedância e diagrama de radiação de forma mensurável.

## Slide 11 — De Maxwell à equação da onda

- As equações de Maxwell do slide são gerais, mas a forma simples da equação da onda aparece depois de fazer hipóteses fortes: vácuo, região sem fontes livres, meio linear, homogêneo, isotrópico e sem perdas. Essas hipóteses deixam `D = epsilon_0 E` e `B = mu_0 H`, com `rho = 0` e `J = 0`.
- Fora do vácuo, mudam as relações constitutivas. Em um dielétrico simples, usamos aproximadamente `D = epsilon E` e `B = mu H`; a velocidade vira `v = 1/sqrt(mu epsilon)`, normalmente menor que `c`. Por isso o comprimento de onda dentro do material é menor: `lambda = v/f`, não `c/f`.
- Em meios com perdas, aparece condução: `J = sigma E`. A permissividade efetiva fica complexa, a onda atenua com a distância e a impedância do meio também fica complexa. É o caso de solo, água, paredes, corpo humano, cabos dielétricos com perdas e muitos materiais reais em RF.
- Em meios dispersivos, `epsilon`, `mu` ou `sigma` dependem da frequência. Isso faz diferentes componentes espectrais viajarem com velocidades e atenuações diferentes, distorcendo pulsos. Em telecomunicações, dispersão importa muito em fibras, guias, substratos, solo e atmosfera em certas faixas.
- Em meios anisotrópicos ou não homogêneos, `D` pode não ser paralelo a `E`, e as propriedades mudam com direção ou posição. Cristais, plasma ionosférico, ferrites e metamateriais são exemplos em que a versão “onda plana no vácuo” deixa de capturar a física completa.
- A mensagem didática é que Maxwell não muda; o que muda é o modelo do meio. As constantes `epsilon_0` e `mu_0` são substituídas por propriedades materiais, e a onda passa a ter outra velocidade, outro comprimento de onda, outra impedância e possivelmente perdas, dispersão e polarização mais complexa.

## Slide 12 — Onda plana uniforme, `eta_0` e Poynting

- `eta_0 approx 377 Omega` é a impedância intrínseca do vácuo: em uma onda plana uniforme no espaço livre, ela é a razão entre os módulos dos campos `E` e `H`, isto é, `E/H`. A unidade dá ohm porque `E` está em V/m e `H` em A/m; `(V/m)/(A/m) = V/A = Omega`.
- Essa impedância não é a mesma coisa que a impedância característica de um cabo coaxial. No coaxial, `Z0` relaciona tensão e corrente do modo guiado pela geometria do cabo e pelo dielétrico. No espaço livre, `eta_0` relaciona campo elétrico e campo magnético de uma onda plana já formada.
- Portanto, um coaxial de `377 Omega` terminado simplesmente “no vácuo” não vira automaticamente uma transição sem reflexão para o espaço livre. Na ponta do cabo há uma descontinuidade geométrica: o modo TEM confinado entre condutor interno e malha precisa virar uma onda radiada no espaço. Sem uma estrutura de transição, como antena, abertura, corneta ou outro adaptador eletromagnético, haverá reflexão, campos reativos e radiação ineficiente.
- É possível projetar antenas ou transições com boa adaptação ao espaço livre, mas isso não acontece apenas igualando o número `377 Omega`. O casamento precisa converter o modo guiado para um modo radiado com distribuição espacial correta de campos, fase e abertura.
- Na onda plana viajante do slide, `E` e `H` estão em fase. As densidades instantâneas de energia elétrica e magnética são proporcionais a `E^2` e `H^2`, então ambas variam como `cos^2(omega t - k z)`. Elas são sempre não negativas e têm máximos e zeros nos mesmos instantes e posições.
- Isso não viola conservação de energia. A conservação local é dada pelo teorema de Poynting: a variação da energia armazenada em um volume é compensada pelo fluxo de energia que entra ou sai desse volume. Quando a energia instantânea em um ponto diminui, a energia não “sumiu”; ela foi transportada para regiões vizinhas pela própria onda.
- A intuição “energia elétrica vira energia magnética e depois volta” é boa para um circuito ressonante LC ou para uma onda estacionária, mas não para uma onda plana viajante no vácuo. Na onda viajante, as partes elétrica e magnética seguem juntas e transportam energia na direção de propagação.
- O vetor de Poynting instantâneo para os campos escritos com amplitude de pico é `S(z,t) = (E_0^2/eta_0) cos^2(omega t - k z) hat(z)`. O valor médio no tempo usa `mean(cos^2) = 1/2`, então `mean(S) = E_0^2/(2 eta_0) hat(z)`. Se os campos forem expressos em valor RMS, a fórmula média fica `mean(S) = E_rms^2/eta_0`.
- A fórmula fasorial `1/2 Re{E x H*}` assume fasores com amplitude de pico. Muitos instrumentos e planilhas usam RMS; por isso é comum errar um fator 2 ao misturar convenções.

## Slide 13 — `lambda`, dimensões elétricas e campo próximo vs. distante

- `D` é a maior dimensão física da antena ou da abertura que está radiando. Para um dipolo fino, `D` é aproximadamente o comprimento total do dipolo. Para uma Yagi, costuma ser a maior dimensão relevante do conjunto, como o comprimento do boom ou a extensão máxima entre elementos. Para uma parábola, `D` é o diâmetro da abertura.
- `D` não é a distância até a antena; a distância radial até o ponto de observação é `r`. A comparação importante é entre `r`, `lambda` e `D`, porque ela diz se estamos vendo o campo ainda acoplado ao radiador ou uma onda já formada.
- `Fraunhofer` é o nome da região de campo distante. Nessa região, a curvatura da frente de onda é pequena vista pela antena, os campos são praticamente transversais, `E/H` se aproxima da impedância do meio, o diagrama angular da antena já não muda com a distância e a potência cai aproximadamente com `1/r^2`.
- O critério usual `r > 2D^2/lambda` vem de limitar o erro de fase entre o centro e a borda de uma abertura. Ele é especialmente importante para antenas grandes em comprimentos de onda, como parábolas, arrays e Yagis longas.
- Muitas referências dividem o campo próximo em duas sub-regiões. A primeira é o campo próximo reativo, muito perto da antena, onde predominam termos que armazenam energia e voltam para o radiador; é a região em que a antena se parece mais com parte de um circuito. Para antenas eletricamente pequenas, uma regra didática é `r < lambda/(2 pi)`.
- A segunda é o campo próximo radiativo, também chamado região de Fresnel. Nela já há energia radiada indo embora, mas o diagrama e as relações de fase ainda dependem da distância; ainda não é seguro usar as simplificações de campo distante.
- Depois vem o campo distante, ou Fraunhofer. Ali predominam os termos radiados proporcionais a `1/r`; os termos reativos `1/r^2` e `1/r^3` já são desprezíveis.
- As fronteiras não são paredes físicas. `lambda/(2 pi)` e `2D^2/lambda` são critérios de engenharia. Perto das fronteiras, as regiões se misturam, e o comportamento real depende da geometria da antena, do solo, de objetos próximos, cabos, mão do operador e estrutura de suporte.
- Para 145,8 MHz, `lambda approx 2,06 m`, então `lambda/(2 pi) approx 33 cm`. Isso explica por que segurar a antena, aproximar o corpo, mudar o cabo ou apoiar a Yagi em uma estrutura metálica pode alterar a impedância medida no NanoVNA mesmo sem mudar o desenho nominal da antena.

## Slide 14 — Como antenas radiam

- `k` é o número de onda, ou constante de fase espacial. Em um meio sem perdas, `k = 2 pi/lambda = omega/v`; no vácuo, `v = c`, então `k = omega/c`. A unidade é radianos por metro.
- Enquanto `omega` diz quão rápido a fase oscila no tempo, `k` diz quão rápido a fase oscila no espaço. Uma variação de distância igual a `lambda` muda a fase em `2 pi` radianos.
- No termo `e^(-j k r_pq)`, `k r_pq` é a fase acumulada pela contribuição que saiu do ponto fonte `r'` e chegou ao ponto de observação `r`. Por isso o termo representa atraso de propagação: fontes mais distantes contribuem com fase diferente.
- Em baixíssima frequência ou em distâncias muito pequenas comparadas com `lambda`, `k r_pq << 1`, então `e^(-j k r_pq) approx 1`. Nesse limite, o atraso quase desaparece e os campos se parecem com campos estáticos ou quase-estáticos: capacitâncias e indutâncias concentradas fazem sentido.
- A radiação aparece quando esse atraso espacial deixa de ser desprezível. Partes diferentes da distribuição de corrente contribuem com fases diferentes, e uma parcela do campo passa a se propagar para longe como termo `1/r`.
- A resistência de radiação `R_r` é uma forma de representar, nos terminais da antena, a potência que não volta para o circuito e não vira calor local: ela sai como onda eletromagnética. Ela não é um resistor físico aquecendo; é uma resistência equivalente associada ao fluxo de Poynting para o campo distante.

## Slide 15 — Dipolo de Hertz: o protótipo analítico

- O dipolo de Hertz é um modelo idealizado, não uma antena prática ressonante. Ele supõe um fio infinitesimal, com `d << lambda`, corrente uniforme ao longo de todo o comprimento e observação no campo distante. Essas hipóteses tornam a conta analítica simples.
- A condição `d << lambda` realmente não descreve um dipolo meia-onda, que tem comprimento total da ordem de `lambda/2`. Por isso é importante não ler este slide como “todo dipolo real é assim”. O slide apresenta o átomo matemático da radiação por corrente curta.
- A fórmula do campo distante mostra três ideias robustas: o campo radiado cresce com corrente, cresce com comprimento elétrico pequeno `d/lambda`, cai como `1/r` e tem fator angular `sin theta`. O máximo aparece perpendicular ao fio e há nulo no eixo do dipolo.
- Para dipolos finos, retos, simétricos e não muito longos, a intuição do padrão em “rosquinha” continua útil: pouca ou nenhuma radiação no eixo do fio e máximo aproximadamente de lado. Um dipolo meia-onda fino ainda tem padrão parecido no plano E e ganho máximo apenas um pouco maior: cerca de `2,15 dBi`, contra `1,76 dBi` do Hertziano.
- O que não generaliza diretamente para `d ~ lambda/2` é a corrente uniforme nem a fórmula `R_r prop (d/lambda)^2`. Em um dipolo meia-onda, a corrente é aproximadamente senoidal, a impedância de entrada depende fortemente do comprimento e do raio do fio, e a resistência de radiação/entrada na ressonância fica da ordem de `73 Omega`, não “minúscula”.
- Para dipolos ainda mais longos, aparecem lóbulos adicionais e o padrão deixa de ser simplesmente um oito no corte vertical. A conclusão “máximo de lado, zero no eixo” ainda pode sobreviver em muitos casos de fio reto fino, mas a distribuição angular completa precisa ser calculada pela distribuição real de corrente.
- Portanto, o dipolo de Hertz serve como referência física e matemática: ele explica por que corrente acelerada em um pequeno trecho radia, por que antenas eletricamente pequenas têm baixa resistência de radiação e por que o padrão elementar tem fator `sin theta`. Para projeto real, ele é ponto de partida, não ponto de chegada.

## Slide 16 — Dipolo curto real: corrente triangular e `R_r` pequeno

- O “dipolo curto real” ainda é curto no sentido elétrico: seu comprimento total `d` é muito menor que `lambda`, tipicamente algo como `d < lambda/10` para a aproximação ser confortável. Ele continua obedecendo à ideia `d << lambda`, mas não é mais o dipolo infinitesimal ideal com corrente uniforme.
- A diferença principal em relação ao dipolo de Hertz é a distribuição de corrente. Em um fio físico centro-alimentado e aberto nas pontas, a corrente precisa cair a zero nas extremidades. Para um dipolo curto, uma aproximação simples é triangular: máxima no centro e zero nas pontas.
- Como o campo distante depende da integral da corrente ao longo do fio, não basta usar o comprimento físico `d`; importa a área sob a curva `I(z)`. Uma corrente uniforme `I_0` ao longo de `d` tem área `I_0 d`. Uma corrente triangular com pico `I_0` no centro e zero nas pontas tem área aproximadamente `I_0 d/2`.
- É daí que vem o comprimento efetivo `d_eff approx d/2`: o dipolo curto real radia, no campo distante, aproximadamente como um dipolo de Hertz de comprimento `d/2` percorrido por corrente uniforme igual à corrente de alimentação máxima.
- Como a potência radiada é proporcional ao quadrado do comprimento efetivo, a resistência de radiação do dipolo curto real fica quatro vezes menor que a do dipolo de Hertz com o mesmo comprimento físico e mesma corrente de pico. Por isso aparece `R_r approx 20 pi^2 (d/lambda)^2 Omega`, em vez de `80 pi^2 (d/lambda)^2 Omega`.
- O comprimento efetivo também aparece em recepção. Ele relaciona o campo elétrico incidente à tensão de circuito aberto nos terminais: de forma simplificada, `V_oc approx E dot h_eff`. Ou seja, ele mede quanto da onda incidente a geometria da antena consegue converter em tensão útil.
- Dipolos muito curtos têm dois problemas simultâneos: `R_r` muito pequeno e reatância capacitiva grande. Mesmo que se use uma rede de casamento para cancelar a reatância, a eficiência pode ser ruim se as perdas ôhmicas, de bobina, de solo ou de contato forem comparáveis ou maiores que `R_r`.
- Para um dipolo meia-onda, a palavra “curto” já não se aplica. A corrente deixa de ser triangular simples, a antena pode estar perto da ressonância, a reatância pode ser pequena e a resistência de entrada passa para dezenas de ohms. Nesse regime, os resultados do slide 16 deixam de ser aproximações quantitativas válidas.

## Slide 17 — Diretividade, ganho, abertura efetiva e polarização

- Diretividade não mede eficiência. Ela mede apenas como a antena redistribui angularmente a potência que conseguiu radiar. Uma antena pode ser muito diretiva e ainda assim ruim se perder muita potência em calor, solo, cabos ou rede de casamento.
- Ganho inclui eficiência de radiação: `G = eta_r D`. Por isso duas antenas com o mesmo diagrama geométrico podem ter ganhos diferentes se uma delas tiver perdas maiores.
- `dBi` significa ganho em dB relativo a uma antena isotrópica ideal. `dBd` significa ganho relativo a um dipolo meia-onda. Como um dipolo meia-onda tem cerca de `2,15 dBi`, vale aproximadamente `G_dBi = G_dBd + 2,15`.
- A aproximação `G_0 approx 4 pi / Omega_B` é uma intuição de conservação de potência: se a antena concentra a energia em um ângulo sólido pequeno, a intensidade naquele feixe sobe. Ela é boa para feixes estreitos; para antenas de diagrama largo, lóbulos laterais relevantes ou formas irregulares, o ganho vem da integração do diagrama completo.
- Abertura efetiva `A_e` não é necessariamente a área física da antena. Ela é a área equivalente que, recebendo uma densidade de potência incidente, entregaria a mesma potência ao receptor se a antena estivesse casada e com polarização correta.
- A relação `A_e = G lambda^2/(4 pi)` mostra uma consequência importante: para o mesmo ganho, a abertura efetiva cresce com `lambda^2`. Em frequências mais baixas, uma antena com o mesmo ganho “captura” uma área efetiva maior, mas costuma exigir dimensões físicas maiores.
- Polarização é a trajetória do vetor `E` no tempo, vista na direção de propagação. Linear horizontal/vertical são casos simples; circular direita/esquerda (`RHC`/`LHC`) são úteis em satélites porque a orientação relativa muda durante a passagem.
- Descasamento de polarização vira perda no enlace. Linear horizontal recebida por linear vertical ideal dá perda infinita no modelo ideal; na prática há alguma recepção por reflexões, imperfeições e multipercurso. Linear contra circular perde tipicamente `3 dB`, se todo o resto estiver alinhado.

## Slide 18 — A antena vista como circuito: `R_r + R_d + jX`

- A impedância de antena é uma descrição nos terminais de alimentação. O transmissor não “sabe” quais watts viram onda e quais viram calor; ele enxerga uma impedância equivalente.
- `R_r` é a parte resistiva associada à potência radiada. `R_d` é a parte resistiva associada a perdas reais: resistência do metal, efeito pelicular, perdas dielétricas, solo, balun, bobinas, capacitores, conectores e correntes indesejadas no cabo.
- Do ponto de vista de casamento, `R_r` e `R_d` parecem resistências comuns. Do ponto de vista de comunicação, são completamente diferentes: potência em `R_r` chega ao campo distante; potência em `R_d` aquece alguma coisa.
- A eficiência `eta_r = R_r/(R_r + R_d)` mostra por que antenas eletricamente curtas são difíceis. Se `R_r` é muito pequeno, uma perda aparentemente pequena de `1 Omega` pode destruir a eficiência.
- A reatância `jX` não representa potência média consumida; ela representa energia que vai e volta entre o gerador e o campo próximo. Mesmo sem dissipar potência média, reatância grande dificulta o casamento, aumenta tensões/correntes e estreita a largura de banda.
- A impedância de entrada depende do ponto de alimentação. Um mesmo fio pode apresentar impedância baixa no centro e muito alta perto de um ponto de corrente mínima. Por isso “a impedância da antena” sempre significa “vista destes terminais, nesta geometria e nesta frequência”.

## Slide 19 — De onde vêm o “L” e o “C” da antena?

- O modelo `RLC` é uma aproximação local em frequência, não uma afirmação de que existe literalmente um indutor e um capacitor escondidos na antena. A antena tem campos distribuídos no espaço; o circuito equivalente resume o comportamento visto pela porta.
- Quando predomina energia elétrica armazenada no campo próximo, a antena parece capacitiva (`X < 0`). Isso é típico de dipolos curtos e monopolos curtos: há carga acumulada nas extremidades e forte campo elétrico próximo.
- Quando predomina energia magnética armazenada associada à corrente, a antena parece indutiva (`X > 0`). Isso ocorre quando a antena passa do comprimento de ressonância ou quando a geometria favorece laços/caminhos de corrente.
- Em ressonância de uma porta, `X approx 0`. Isso não significa que não existe energia reativa no campo próximo; significa que, na frequência e no ponto de alimentação considerados, as parcelas elétrica e magnética se compensam no equivalente visto pelo gerador.
- A ressonância não garante eficiência. Uma antena pequena pode ser ajustada para `X = 0` com bobina de carga e ainda radiar pouco se `R_r` for pequeno e as perdas forem grandes.
- Simuladores como NEC/PyNEC e OpenEMS não começam de um `RLC`; eles resolvem campos e correntes. O `RLC` aparece depois, como forma de interpretar a impedância calculada ou medida em torno de uma frequência.

## Slide 20 — Antena curta capacitiva; longa indutiva

- A primeira ressonância de um dipolo fino real ocorre abaixo de `lambda/2`, tipicamente em `0,47--0,48 lambda`, porque a onda de corrente no fio não termina exatamente onde termina o metal de forma idealizada. Há efeito de ponta, capacitância das extremidades, diâmetro finito do condutor, isoladores, alimentação e ambiente próximo.
- Uma forma prática de dizer isso é que o dipolo tem um “comprimento elétrico” ligeiramente maior que o comprimento físico. Para ele se comportar eletricamente como meia onda, o fio físico precisa ser um pouco menor que `lambda/2`.
- O valor exato não é universal. Dipolos mais grossos tendem a ser ainda um pouco mais curtos na ressonância e têm maior largura de banda. Altura sobre o solo, proximidade de objetos, isolamento nas pontas, ângulo em V invertido e o próprio cabo de alimentação também deslocam a frequência de ressonância.
- Para um dipolo fino centro-alimentado, abaixo da primeira ressonância a impedância é capacitiva; acima dela, fica indutiva por um intervalo. A interpretação por “linha aberta truncada” ajuda: antes de completar a condição ressonante, há excesso de energia elétrica; depois, excesso de energia magnética.
- Quando o comprimento total se aproxima de `lambda`, o centro do dipolo se aproxima de uma região de corrente pequena e tensão alta. Isso produz antirressonância: a impedância de entrada fica muito alta e varia rapidamente com frequência.
- O padrão também muda porque a distribuição de corrente ao longo do fio já não parece uma única meia-senoide simples. Perto de `lambda`, o feixe broadside ainda pode existir, mas fica mais estreito e a distribuição de corrente cria regiões com fase diferente ao longo do fio. À medida que o comprimento passa de uma onda, lóbulos laterais e divisões do lóbulo principal ficam cada vez mais importantes; em comprimentos como `3 lambda/2`, o máximo já pode se deslocar para ângulos fora da direção perpendicular.
- As desvantagens de usar a antirressonância em vez da primeira ressonância são práticas: impedância muito alta, difícil de casar com 50 ohms; alta tensão no ponto de alimentação; maior sensibilidade a chuva, mão, solo, cabo e pequenos erros de comprimento; largura de banda estreita; perdas maiores na rede de casamento; e padrão menos previsível para cobertura simples.
- A primeira ressonância de meia onda é popular porque combina impedância manejável, corrente máxima no centro, tensão moderada, padrão simples, boa eficiência e casamento relativamente fácil. A antirressonância pode ser explorada em projetos específicos, mas raramente é a escolha mais robusta para uma antena didática ou portátil.

## Slide 21 — Casamento externo: por que a eficiência cai?

- `Q` é fator de qualidade. Em termos físicos, mede quanta energia reativa fica armazenada em relação à energia perdida por ciclo. Uma forma comum é `Q = omega * energia armazenada / potencia dissipada`. Em um indutor série, isso vira aproximadamente `Q_L = omega L / R_s`; em um capacitor série, `Q_C = 1/(omega C R_s)`. Também se usa `Q approx f_0/BW` para um sistema ressonante de banda estreita.
- Um indutor ideal concentrado teria `Q` infinito, porque armazenaria energia magnética sem dissipar potência. Indutor real sempre tem `Q` finito por resistência do fio, efeito pelicular, efeito de proximidade, perdas no núcleo, perdas dielétricas do suporte, radiação parasita e capacitância entre espiras.
- O `Q` de uma bobina de carga importa muito porque a corrente nela pode ser alta. A bobina cancela a reatância capacitiva da antena curta, mas sua resistência série real entra em série com `R_r`. Se `R_r` vale centésimos de ohm, uma bobina com poucos ohms de perda pode consumir quase toda a potência.
- Um capacitor ideal concentrado também teria `Q` infinito. Capacitor real tem `Q` finito por resistência série equivalente (`ESR`), perdas dielétricas, resistência dos terminais, aquecimento, fuga e, em RF, indutância parasita. Em geral capacitores bons têm `Q` maior que bobinas, mas isso não significa perda zero.
- “Lumped” é um modelo, não garantia de idealidade. Podemos modelar um indutor ou capacitor como concentrado quando suas dimensões são pequenas frente ao comprimento de onda e os parasitas são aceitáveis. Dentro desse modelo, o componente pode ser ideal ou pode incluir `R_s`, `ESR`, capacitâncias e indutâncias parasitas.
- Casar impedância não cria resistência de radiação. A rede de casamento pode fazer o transmissor enxergar `50 Omega`, mas a eficiência continua limitada por `R_r/(R_r + perdas)`. É por isso que uma antena muito curta pode apresentar ROE boa e ainda irradiar mal.
- Contrapeso é o condutor, conjunto de radiais, malha, plano metálico ou estrutura que fornece o caminho de retorno de corrente para uma antena assimétrica, como um monopolo vertical. Ele funciona como a “outra metade” elétrica da antena.
- Sem contrapeso adequado, a corrente de retorno passa por solo, corpo do operador, carcaça do rádio, cabo coaxial, fiação do prédio ou objetos próximos. Isso aumenta perdas, muda o padrão, causa RF no shack e torna o ajuste instável. Em portátil, um simples fio radial ou conjunto de radiais já pode melhorar muito uma vertical curta.

## Slide 22 — Onde ocorrem as perdas na prática cotidiana?

- Skin effect, ou efeito pelicular, é a tendência de corrente alternada em alta frequência se concentrar perto da superfície do condutor. Ele acontece porque o campo magnético variável induz campos que se opõem à corrente no interior do metal, empurrando a corrente efetiva para a periferia. A profundidade de pele diminui com a frequência; a área útil de condução cai e a resistência AC sobe.
- Proximity effect, ou efeito de proximidade, é a redistribuição de corrente causada pelo campo magnético de condutores próximos. Em uma bobina, espiras vizinhas induzem campos umas nas outras e a corrente se concentra em regiões específicas do fio, aumentando ainda mais a resistência AC. Por isso uma bobina compacta pode aquecer mais que o esperado pela resistência DC do fio.
- Núcleo de ferrite pode saturar porque ferrite não é material linear ilimitado. Acima de certo campo magnético, os domínios magnéticos já estão quase alinhados e a permeabilidade efetiva cai. Em transmissão, corrente alta em bobinas, chokes ou transformadores pode levar o núcleo a essa região, aumentando distorção, aquecimento e perda de indutância. Perdas também crescem com frequência e fluxo, mesmo antes de saturação forte.
- Sobre solo úmido: para radiais ruins ou ausentes, solo mais condutivo geralmente reduz perdas de retorno, então úmido costuma ser melhor que muito seco. Mas “úmido” não é sempre ideal em tudo: permissividade, salinidade, estratificação e absorção variam, e solo pode também absorver energia de campo próximo.
- Com radiais bem feitos, o solo importa menos para a resistência de perda de retorno, porque a corrente volta majoritariamente pelos radiais metálicos. Ele ainda importa para ângulo de radiação, reflexão no solo e perdas residuais, mas deixa de ser o principal “resistor” em série com a antena.
- Onda estacionária se forma quando há uma onda incidente e uma onda refletida na linha. A reflexão principal surge onde a impedância da carga não coincide com a impedância característica do cabo, por exemplo no feedpoint se a antena não apresenta `50 Omega` para um coaxial de `50 Omega`.
- Se o rádio é bem casado a `50 Omega` e o cabo também é de `50 Omega`, uma onda que retorna ao rádio tende a ser absorvida pela impedância de saída equivalente do transmissor ou por circuitos de proteção/acoplamento, não refletida integralmente. Na prática, o PA não é uma carga perfeita em todas as condições, então pode haver alguma re-reflexão, mas a reflexão que define a ROE normalmente é a do lado da antena.
- A onda estacionária não é uma “bola de energia presa para sempre” no coaxial. Em regime permanente, há potência indo e voltando simultaneamente; parte é entregue à antena, parte retorna, parte é dissipada no cabo e parte pode voltar ao transmissor. Se houver múltiplas reflexões, elas se somam até chegar a um regime estacionário compatível com as terminações.
- O risco para o PA vem principalmente da potência refletida chegando de volta ao transmissor, das tensões e correntes elevadas em certos pontos da linha e da atuação fora da impedância para a qual o estágio foi projetado. Muitos rádios modernos reduzem potência quando detectam ROE alta. A onda estacionária dentro do cabo também aumenta perdas no cabo, porque a corrente e a tensão RMS em trechos da linha podem ser maiores que no caso casado.
- Corrente de modo comum em coaxial é corrente que flui no mesmo sentido na parte externa da malha e em outros condutores próximos, sem ter corrente oposta correspondente no condutor interno. O modo normal desejado é diferencial/TEM dentro do cabo: corrente no condutor interno e retorno na face interna da malha. Corrente na face externa da malha faz o cabo virar parte da antena.
- Corrente de modo comum pode distorcer o diagrama, deslocar impedância, levar RF para o rádio/computador, aumentar ruído recebido e tornar a antena sensível à posição do cabo. Em recepção, o cabo também passa a captar ruído local como se fosse antena.
- Balun significa balanced-to-unbalanced. Em dipolos, Yagis e outras antenas balanceadas alimentadas por coaxial desbalanceado, ele ajuda a impedir que a corrente use o lado externo da malha como caminho. Muitas vezes o dispositivo usado é especificamente um choke de modo comum, que aumenta a impedância para modo comum sem necessariamente transformar impedância.
- Muita gente opera sem balun e “funciona” porque a antena ainda radia e o rádio ainda faz contatos. Isso não prova que está ideal; só mostra que o sistema encontrou algum caminho de retorno, frequentemente pelo próprio coaxial. Em HF, perdas moderadas e comprimentos de cabo favoráveis podem mascarar o problema. Em VHF/UHF ou em antenas direcionais, o efeito costuma ficar mais visível no padrão, na ROE ao mexer no cabo e no ruído recebido.
- A regra prática é: sem balun/choke pode funcionar, mas é menos controlado e menos repetível. Para medições, Yagis, antenas próximas ao operador, estações com RFI ou projetos didáticos em que queremos que o padrão seja o da antena e não do cabo, usar choke/balun adequado é a escolha correta.

## Slide 23 — Ressonância e a analogia com linha TEM

- A analogia com linha TEM é útil porque um dipolo pode ser visto como uma estrutura distribuída: corrente e tensão variam ao longo do fio, não estão concentradas em um único ponto como em um circuito pequeno.
- Na primeira ressonância, o ponto de alimentação vê `X approx 0`. Isso não quer dizer que não haja campo próximo ou energia reativa; quer dizer que, vista pela porta, a energia elétrica e magnética armazenadas se compensam em média naquela frequência.
- Perto de `d approx lambda`, o centro do dipolo fica próximo de um nó de corrente e de uma região de tensão alta. Como `Z = V/I`, corrente pequena no ponto de alimentação significa impedância muito alta. Essa é a intuição da antirressonância.
- Em uma Yagi, os elementos parasitas não são alimentados por cabo, mas não estão “desligados”. O campo do elemento ativo induz corrente neles. Cada elemento responde como um ressonador com comprimento, diâmetro, perdas e `Q` próprios.
- O refletor costuma ser ligeiramente mais longo que o elemento ativo, ficando indutivo na frequência de operação. O diretor costuma ser ligeiramente mais curto, ficando capacitivo. Essa diferença de fase nas correntes induzidas ajuda a reforçar o campo para um lado e cancelar para o outro.
- A palavra “forçada” significa que a corrente no parasita é determinada simultaneamente pela sua ressonância própria e pelo acoplamento com os demais elementos. Mudar espaçamento ou comprimento altera amplitude e fase das correntes, e por isso muda ganho, relação frente-costas, impedância de entrada e largura de banda.
- Isso explica por que uma Yagi é sensível a detalhes mecânicos. Um erro pequeno em VHF/UHF pode ser fração relevante de comprimento de onda, e a antena deixa de ter o padrão simulado mesmo que “pareça” uma Yagi.

## Slide 24 — Linha de transmissão: `Z0`, `Gamma` e SWR

- `Z0` é a impedância característica da linha: a razão entre tensão e corrente de uma onda viajante única naquela linha. Ela não é simplesmente a resistência DC do cabo; vem da indutância por metro `L'` e da capacitância por metro `C'`, além das perdas reais quando incluímos `R'` e `G'`.
- `v_p` é a velocidade de fase da onda na linha. Em uma linha ideal sem perdas, `v_p = 1/sqrt(L'C')`. No vácuo seria `c`; em um coaxial real é menor porque o dielétrico aumenta a capacitância e reduz a velocidade.
- `VF` é o velocity factor, ou fator de velocidade: `VF = v_p/c`. Um RG-58 sólido típico tem `VF approx 0,66`, então a onda viaja a cerca de 66% da velocidade da luz. Isso também encurta o comprimento de onda dentro do cabo: `lambda_cabo = VF * lambda_espaco_livre`.
- O coeficiente de reflexão `Gamma` é mais fundamental que SWR: ele tem magnitude e fase. A magnitude `|Gamma|` diz qual fração da amplitude da onda de tensão é refletida; `|Gamma|^2` dá a fração de potência refletida em uma linha sem perdas. A fase diz onde ficam máximos e mínimos de tensão/corrente ao longo da linha.
- As pessoas usam SWR/ROE porque é fácil de medir com instrumentos simples e tem interpretação operacional direta: `1:1` é casado; `2:1`, `3:1` etc. indicam severidade prática do descasamento. Historicamente, medidores de ROE são mais simples e baratos que instrumentos que mostram `Gamma` complexo.
- SWR também é independente da fase de `Gamma`: ele resume apenas a razão entre máximo e mínimo de tensão na linha. Isso é suficiente para muitas decisões de campo, como “posso transmitir?”, “o rádio vai reduzir potência?” ou “a antena está perto do ajuste?”.
- A desvantagem é que SWR perde informação. Dois sistemas com mesmo SWR podem ter impedâncias muito diferentes, uma capacitiva e outra indutiva. Para projetar casamento, cortar cabo com intenção de transformação ou ajustar antena com precisão, `Gamma` complexo, impedância ou gráfico de Smith são mais informativos.
- A relação `SWR = (1 + |Gamma|)/(1 - |Gamma|)` mostra que as grandezas são equivalentes se só queremos a magnitude da reflexão. Exemplos úteis: `SWR = 2:1` corresponde a `|Gamma| = 1/3` e potência refletida de cerca de 11%; `SWR = 3:1` corresponde a `|Gamma| = 0,5` e potência refletida de 25%.
- A afirmação `|Gamma(z)| = |Gamma_L|` vale para linha ideal sem perdas porque a onda incidente e a onda refletida sofrem a mesma atenuação: nenhuma, nesse modelo. Ao caminhar pela linha, a fase relativa muda, então `Gamma` gira no plano complexo, mas sua magnitude fica constante.
- Em uma linha com perdas, isso deixa de ser verdade. A onda refletida precisa percorrer a linha de volta e é atenuada; quanto mais longe da carga medimos, menor tende a parecer `|Gamma|`. Por isso um cabo muito longo e com perdas pode mostrar ROE bonita no rádio mesmo com antena ruim: parte da potência foi dissipada no cabo, não entregue à antena.
- Quando o slide diz que a fase gira 360 graus a cada `lambda/2`, a consequência prática é que a impedância medida muda ao longo do cabo mesmo que a antena não tenha mudado. Em linha sem perdas, `|Gamma|` fica igual, mas a fase de `Gamma` muda; como `Z(z)` depende de `Gamma(z)`, a impedância vista pelo instrumento ou pelo rádio muda com a posição.
- Exemplo conceitual: uma antena pode ter `Z_L = 25 + j30 Omega` no feedpoint. Se houver um pedaço de coaxial entre o NanoVNA e a antena, o VNA pode enxergar outro valor, como uma impedância mais alta, mais baixa, capacitiva ou indutiva, dependendo do comprimento elétrico do cabo. A antena não mudou; a linha transformou a impedância.
- Isso explica três regras práticas. Um cabo de `lambda/2` repete a impedância da carga na outra ponta, na frequência considerada. Um cabo de `lambda/4` transforma impedância de forma forte, sendo a base dos transformadores quarto-de-onda. Comprimentos intermediários movem o ponto ao redor do gráfico de Smith.
- Por isso, se a intenção é medir a antena, o NanoVNA deve ser calibrado no plano de referência correto: idealmente no feedpoint ou no fim do cabo que chega à antena. Se a calibração fica na porta do instrumento e há um cabo desconhecido no meio, a medição mistura antena e transformação da linha.
- A mesma ideia explica por que “cortar coaxial para melhorar ROE” pode ser enganoso. Em alguns casos, mudar o comprimento do cabo altera a impedância vista pelo rádio e melhora a ROE naquele ponto, mas não torna a antena mais eficiente nem reduz necessariamente a potência refletida no feedpoint. Pode apenas deslocar onde, na linha, estamos observando a transformação.
- Cuidado prático: o comprimento elétrico do cabo usa `lambda_cabo`, não `lambda` no ar. Um trecho de `lambda/4` em coaxial com `VF = 0,66` tem comprimento físico `0,66 * lambda_0/4`.

## Slide 25 — Linha como transformador de impedância

- Uma Delta Loop é uma antena de fio em formato aproximadamente triangular, normalmente com perímetro próximo de uma onda completa na frequência de projeto. Ela pode ser alimentada em pontos diferentes do triângulo, o que muda impedância e polarização. Em HF, é popular porque usa fio, pode ter bom rendimento e ocupa menos largura horizontal que alguns dipolos de onda completa.
- A impedância de uma Delta Loop de onda completa pode ficar em torno de `100--120 Omega` em algumas geometrias e pontos de alimentação. Por isso aparece o exemplo de casar `50 Omega` a `112 Omega` usando um trecho de `75 Omega` com comprimento elétrico de `lambda/4`, já que `sqrt(50 * 112) approx 75`.
- Um stub é um pedaço de linha de transmissão usado como componente reativo. Ele pode ser aberto ou curto-circuitado na ponta e conectado em série ou em paralelo ao sistema. Em uma frequência específica, o stub se comporta como uma capacitância ou indutância equivalente.
- A vantagem do stub é que, em RF, às vezes é mais fácil e mais estável sintetizar uma reatância com um pedaço de linha do que com um capacitor ou indutor concentrado. Em VHF/UHF, alguns centímetros de linha já podem representar uma reatância significativa.
- Um stub curto-circuitado menor que `lambda/4` costuma parecer indutivo na entrada; um stub aberto menor que `lambda/4` costuma parecer capacitivo. Acima de `lambda/4`, o sinal da reatância inverte. Por isso o comprimento elétrico e o fator de velocidade são essenciais.
- O `hairpin match` de Yagi é uma aplicação dessa ideia: uma reatância indutiva em paralelo, muitas vezes implementada como uma pequena seção de linha ou barra em U, compensa a reatância capacitiva do ponto de alimentação e ajuda a transformar a impedância para perto de `50 Omega`.
- Um transformador de `lambda/4` só casa bem em uma faixa limitada. Fora da frequência de projeto, o comprimento já não é exatamente `lambda/4` e a transformação muda. Isso é aceitável em antenas estreitas ou enlaces de frequência fixa, mas pode ser ruim em operação multibanda.

## Slide 26 — Ladder line vs coaxial

- Ladder line dissipa menos com ROE alta por dois motivos principais: sua perda casada já é muito menor e, para a mesma potência, os campos ficam majoritariamente no ar, não em dielétrico sólido. Coaxial típico tem mais perda por resistência dos condutores, efeito pelicular na malha/condutor central e perdas dielétricas; ladder/open-wire usa condutores mais espaçados e quase só ar entre eles.
- A conta de perda com descasamento mostra por que isso importa. Seja `A = 10^(-ML/10)` a fração de potência que atravessaria a linha em um sentido se ela estivesse casada, onde `ML` é a perda casada em dB. Seja `rho = |Gamma_L|` na carga. Com fonte casada, a potência entregue à carga em relação à potência líquida de entrada fica aproximadamente:
  `P_load/P_in = A (1 - rho^2) / (1 - rho^2 A^2)`.
- A perda total da linha, incluindo o efeito da ROE, é então:
  `Loss_dB = 10 log10((1 - rho^2 A^2) / (A (1 - rho^2)))`.
- Se a linha fosse sem perdas, `A = 1`, e a expressão daria perda zero mesmo com ROE alta: a potência refletida voltaria ao transmissor ou seria re-refletida, mas não seria dissipada na linha. A ROE só vira aquecimento significativo quando a linha tem atenuação real.
- Exemplo com `SWR = 10:1`: `rho = (SWR - 1)/(SWR + 1) = 9/11 approx 0,818`, então `rho^2 approx 0,67`. Se um trecho de coaxial tem perda casada `ML = 1,5 dB`, então `A approx 0,71` e a perda total sobe para cerca de `4,5 dB`. A linha dissiparia aproximadamente dois terços da potência líquida de entrada antes que a carga recebesse o restante.
- Com a mesma ROE `10:1`, mas ladder line com perda casada `ML = 0,1 dB`, `A approx 0,98` e a perda total fica da ordem de `0,3 dB`. A ROE é a mesma, mas a potência circulante extra quase não aquece a linha porque a linha é de baixa perda.
- Portanto, “ladder line tolera ROE alta” não significa que ROE alta é magicamente boa; significa que a penalidade de potência dissipada na linha permanece pequena porque a linha é muito pouco dissipativa. Em coaxial longo, a mesma ROE pode ser cara em dB.
- Doublet é uma antena de fio balanceada, parecida com um dipolo, mas não necessariamente cortada para ressonar em uma única banda. Ela costuma ser alimentada por linha balanceada e usada com acoplador para operar em várias bandas.
- G5RV é um projeto clássico de antena multibanda criado por Louis Varney, indicativo G5RV. A versão tradicional usa um doublet de cerca de 31 m com uma seção de linha balanceada como transformador e depois coaxial até o rádio. Ela não é “ressonante em todas as bandas”; funciona como compromisso multibanda que ainda precisa de acoplador em muitas instalações.
- Zepp vem de “Zeppelin”: originalmente uma antena de fio alimentada pela ponta, usada em dirigíveis. No uso radioamador, aparecem variações como end-fed Zepp e extended double Zepp, geralmente antenas de fio alimentadas por linha aberta ou sistemas balanceados, com impedâncias altas e necessidade de casamento.
- Se o acoplador fica em uma caixa hermética literalmente ao lado da antena, muitas vezes é melhor descer coaxial casado até o shack. Essa é a lógica de acopladores remotos em verticais, loops e fios longos: a linha coaxial trabalha perto de `50 Omega`, com baixa ROE, e as perdas no coaxial caem bastante.
- Então por que muitos radioamadores deixam o acoplador no shack? Conveniência e custo: o acoplador fica acessível para ajuste manual, protegido de chuva, sem necessidade de alimentação/controle remoto, relés, caixa estanque e proteção contra surtos. Além disso, em HF com ladder line curta ou moderada, as perdas podem continuar pequenas mesmo com ROE alta.
- A escolha prática é esta: acoplador remoto junto à antena é excelente quando a descida seria coaxial longo com ROE alta, ou quando a antena é uma vertical/fio que precisa de casamento no ponto de alimentação. Acoplador no shack com ladder line é excelente para doublets multibanda, porque a linha balanceada aceita impedâncias muito variadas com pouca perda. Acoplador no shack com coaxial longo e antena muito descasada costuma ser a pior combinação.

## Slide 27 — MoM e NEC2: como um simulador de antenas funciona

- Um operador é uma regra que transforma uma função em outra função. Uma matriz transforma um vetor em outro vetor; um operador integral transforma uma função em outra por meio de uma integral.
- Exemplo genérico: `g(x) = L[f](x) = integral K(x,x') f(x') dx'`. A função `K(x,x')` é o núcleo do operador. Ela diz quanto uma fonte localizada em `x'` contribui para o campo observado em `x`.
- Na EFIE, o papel de `f` é a corrente desconhecida no condutor, e o papel de `g` é o campo tangencial que essa corrente produz na superfície do condutor. O núcleo contém a função de Green `e^(-jkr)/r`, que é a resposta do espaço livre a uma fonte pontual.
- A condição física é simples: em um condutor perfeito, o campo elétrico tangencial total na superfície deve ser zero. Assim, o campo aplicado pela fonte mais o campo espalhado pelas correntes induzidas deve cancelar: `E_inc + E_scat(J) = 0`. Rearranjando, obtemos uma equação integral para a corrente desconhecida `J`.
- O Método dos Momentos transforma essa equação funcional infinita em álgebra linear finita em três passos. Primeiro, aproximamos a corrente por uma soma finita de funções conhecidas: `J(s) approx sum_n alpha_n f_n(s)`. Os `alpha_n` são os coeficientes desconhecidos.
- Segundo, substituímos essa expansão na equação integral. Como o operador é linear, `L[J] = sum_n alpha_n L[f_n]`.
- Terceiro, testamos a equação em um número finito de condições. No point-matching, exigimos que a equação valha no centro de cada segmento. Isso gera uma equação por ponto de teste: `sum_n Z_mn alpha_n = V_m`.
- O resultado é uma matriz. Cada `Z_mn` diz quanto a função de base do segmento `n` contribui para o campo/teste no segmento `m`. O vetor `V_m` representa a excitação aplicada. Resolver a matriz dá os coeficientes `alpha_n`, isto é, uma aproximação da corrente na antena.
- Exemplo matemático pequeno, apenas para ver o mecanismo. Considere a equação integral de brinquedo `integral_0^1 (1 + x x') I(x') dx' = 1 + x`. Vamos aproximar `I(x) = a_1 + a_2 x` e testar em `x = 0` e `x = 1`.
- Para `x = 0`: `integral_0^1 (a_1 + a_2 x') dx' = 1`, então `a_1 + a_2/2 = 1`.
- Para `x = 1`: `integral_0^1 (1 + x')(a_1 + a_2 x') dx' = 2`, então `(3/2)a_1 + (5/6)a_2 = 2`.
- Em forma matricial: `[[1, 1/2], [3/2, 5/6]] [a_1, a_2]^T = [1, 2]^T`. Resolvendo, `a_1 = -2` e `a_2 = 6`. O MoM em antenas faz a mesma coisa conceitual, mas com kernel eletromagnético, geometria 3D e muitas funções de base.
- No NEC2, para fios finos, a incógnita principal é a corrente ao longo do eixo do fio. O fio é dividido em segmentos, e a corrente em cada trecho é aproximada por funções simples que se conectam entre segmentos.
- “Pulso” significa uma aproximação constante por segmento: a corrente é tratada como aproximadamente constante dentro de um pequeno trecho. É simples, mas cria descontinuidades artificiais se usado sozinho.
- “Senoidal/pulso+cosseno por segmento” se refere a funções de base/interpolação que permitem representar melhor a variação suave da corrente ao longo de fios finos, respeitando melhor o comportamento ondulatório e a continuidade entre segmentos. Em vez de uma escada grosseira de correntes constantes, o NEC usa formas que se parecem mais com a corrente física em um fio excitado por RF.

## Slide 28 — NEC2: discretização, matriz `Z` e resolução

- Depois de resolver `Z alpha = V`, o simulador tem uma aproximação da corrente em cada segmento. Todo o pós-processamento vem dessa corrente: impedância, potência aceita, potência radiada, padrão e ganho.
- Impedância de entrada: se a porta de alimentação aplica uma tensão fasorial `V_in` e a corrente resultante no segmento alimentado é `I_in`, então `Z_in = V_in/I_in`. Em simulações, muitas vezes se excita com `V_in = 1 V`; nesse caso `Z_in = 1/I_in`, respeitando a convenção fasorial usada.
- Potência aceita pela antena: usando fasores de pico, `P_in = (1/2) Re{V_in I_in*}`. Se forem valores RMS, `P_in = Re{V_rms I_rms*}`. Essa potência é o que entrou na estrutura modelada; parte vira radiação e parte vira perda se o modelo inclui perdas.
- Campo distante: cada pequeno segmento de corrente contribui para o campo radiado com fase e amplitude determinadas por sua corrente e posição. Em forma compacta, no campo distante,
  `E_far(rhat) prop (e^(-jkr)/r) integral J_perp(r') e^(j k rhat dot r') dV'`.
- `J_perp` é a parte da corrente transversal à direção de observação. A exponencial `e^(j k rhat dot r')` soma as contribuições com a fase correta: segmentos em posições diferentes interferem construtiva ou destrutivamente dependendo da direção. É daí que sai o padrão de radiação.
- Para fios discretizados, a integral vira soma sobre segmentos: `E_far(theta,phi) approx sum_n alpha_n F_n(theta,phi)`, onde `F_n` é a contribuição de campo distante da função de base do segmento `n`. O padrão nasce dessa soma complexa.
- Densidade de potência angular: no campo distante, `H = E/eta_0` localmente, então a intensidade de radiação é `U(theta,phi) = r^2 S_avg = r^2 |E_far(theta,phi)|^2/(2 eta_0)` se `E` usa amplitude de pico. Com RMS, remove-se o fator `1/2`.
- Potência radiada: integra-se a intensidade de radiação em todas as direções, `P_rad = integral_{4pi} U(theta,phi) dOmega`. Numericamente, o simulador calcula o campo em uma malha angular e integra/soma.
- Diretividade: `D(theta,phi) = 4 pi U(theta,phi)/P_rad`. O ganho de diretividade máximo é o máximo dessa função.
- Eficiência de radiação: `eta_r = P_rad/P_in` quando `P_in` é a potência aceita nos terminais e o modelo inclui as perdas reais. Equivalentemente, `P_in = P_rad + P_loss`, então `eta_r = P_rad/(P_rad + P_loss)`.
- Ganho: `G(theta,phi) = eta_r D(theta,phi)`. Se também quisermos incluir descasamento com uma linha de `Z0`, usamos ganho realizado: `G_realized = (1 - |Gamma|^2) G`, onde `Gamma = (Z_in - Z0)/(Z_in + Z0)`.
- Perdas ôhmicas podem ser obtidas integrando dissipação no condutor, de forma conceitual `P_loss = (1/2) integral R_s |J_s|^2 dS` para fasores de pico, ou por modelos equivalentes de resistência por segmento. Em fios perfeitos sem perdas, `P_loss = 0` e a eficiência ideal fica 100%.
- A matriz `Z` também contém informação energética. A parte real da impedância vista nos terminais está ligada à potência real aceita; essa potência se divide entre radiação e perdas. A parte imaginária está ligada à energia reativa armazenada no campo próximo.
- Por isso o NEC é tão útil para Yagi: uma vez encontradas as correntes complexas em todos os elementos, o resto é consequência direta de Maxwell. O padrão, o ganho e a impedância não são ajustes separados; todos vêm da mesma solução de corrente.
- A frase “Yagi é poucos fios finos” deve ser lida como “o modelo ideal de Yagi é bem compatível com fio fino”. Uma Yagi real feita com tubos cilíndricos finos costuma ser muito bem representada no NEC2. Uma Yagi feita com fita de trena já é uma aproximação mais agressiva: os elementos são fitas largas, achatadas, flexíveis e levemente curvas, não fios cilíndricos finos.
- Ainda assim, para uma Yagi de fita de trena em 2 m ou 70 cm, o NEC2 pode ser bastante útil se a fita for representada por um fio cilíndrico de raio efetivo e se o objetivo for acertar tendências: comprimento dos elementos, espaçamento, frequência aproximada de ressonância, ganho e relação frente-costas. A largura da fita aumenta o “diâmetro elétrico” do elemento, encurta um pouco o comprimento ressonante e tende a aumentar a largura de banda.
- O cuidado é não confiar em milímetros como se o modelo fosse exato. A curvatura da fita, a fixação no boom, parafusos, abraçadeiras, dobra no ponto de alimentação, isolamento, proximidade da mão e o cabo coaxial podem deslocar a impedância e a frequência mais do que o erro numérico do NEC.
- Uma aproximação comum é usar um raio equivalente para a fita, escolhido para produzir comportamento parecido ao de um condutor cilíndrico. Isso não é uma identidade eletromagnética perfeita; preserva aproximadamente efeitos como capacitância por unidade de comprimento e ressonância, mas não reproduz todos os detalhes de corrente nas bordas da fita.
- Se a fita for muito larga em fração de `lambda`, se a curvatura for forte, se houver superfícies metálicas largas, dielétricos próximos ou geometria 3D importante, o modelo de fio fino deixa de ser a ferramenta certa. Aí faz mais sentido usar um solver com superfícies/volumes, como MoM de superfície ou FDTD, ou então tratar o NEC como ponto de partida e validar tudo no NanoVNA e em teste de campo.

## Slide 29 — FDTD e OpenEMS: simulação por grade de Yee

- `FDTD` significa Finite-Difference Time-Domain: diferenças finitas no domínio do tempo. Em vez de resolver diretamente correntes em condutores por uma equação integral, ele resolve os campos `E` e `H` em muitos pontos do espaço, avançando passo a passo no tempo.
- A grade de Yee intercala campos no espaço e no tempo. Componentes de `E` ficam nas arestas das células; componentes de `H` ficam nas faces. Isso combina naturalmente com os rotacionais de Maxwell, porque cada componente de campo é atualizada a partir da circulação dos campos vizinhos ao redor dela.
- `Leapfrog` significa “salto de sapo”: `E` e `H` não são atualizados no mesmo instante. Calculamos `E` em tempos inteiros `n Delta t` e `H` em tempos meio passo `(n + 1/2) Delta t`. Primeiro `H` usa o `E` conhecido; depois `E` usa o `H` recém-atualizado. Um campo sempre “salta” por cima do outro no tempo.
- No limite de Courant, `Delta x`, `Delta y` e `Delta z` são os espaçamentos da malha nas três direções, e `Delta t` é o passo de tempo. Se a malha for cúbica, muitas pessoas escrevem apenas `Delta` para o tamanho da célula. O critério garante que a informação numérica não tente andar mais rápido que a onda física dentro da malha.
- Em 3D no vácuo, o critério é `c Delta t <= 1/sqrt((1/Delta x)^2 + (1/Delta y)^2 + (1/Delta z)^2)`. Para malha cúbica `Delta x = Delta y = Delta z = Delta`, isso vira `Delta t <= Delta/(c sqrt(3))`.
- Abrindo os rotacionais, no vácuo e sem corrente de condução: `partial E/partial t = (1/epsilon) nabla x H` e `partial H/partial t = -(1/mu) nabla x E`.
- O rotacional de `H` é `nabla x H = (partial H_z/partial y - partial H_y/partial z) xhat + (partial H_x/partial z - partial H_z/partial x) yhat + (partial H_y/partial x - partial H_x/partial y) zhat`.
- O rotacional de `E` é `nabla x E = (partial E_z/partial y - partial E_y/partial z) xhat + (partial E_x/partial z - partial E_z/partial x) yhat + (partial E_y/partial x - partial E_x/partial y) zhat`.
- Exemplo de atualização para `E_x`. A equação contínua é `partial E_x/partial t = (1/epsilon)(partial H_z/partial y - partial H_y/partial z)`. Em diferenças finitas centrais, uma forma típica é:
  `E_x^{n+1}(i+1/2,j,k) = E_x^n(i+1/2,j,k) + (Delta t/epsilon) [ (H_z^{n+1/2}(i+1/2,j+1/2,k) - H_z^{n+1/2}(i+1/2,j-1/2,k))/Delta y - (H_y^{n+1/2}(i+1/2,j,k+1/2) - H_y^{n+1/2}(i+1/2,j,k-1/2))/Delta z ]`.
- O significado físico dessa fórmula é direto: `E_x` aumenta ou diminui conforme a circulação local de `H` ao redor da aresta onde `E_x` está definido. É uma versão discreta da lei de Ampère-Maxwell.
- Exemplo de atualização para `H_x`. A equação contínua é `partial H_x/partial t = -(1/mu)(partial E_z/partial y - partial E_y/partial z)`. Uma forma típica é:
  `H_x^{n+1/2}(i,j+1/2,k+1/2) = H_x^{n-1/2}(i,j+1/2,k+1/2) - (Delta t/mu) [ (E_z^n(i,j+1,k+1/2) - E_z^n(i,j,k+1/2))/Delta y - (E_y^n(i,j+1/2,k+1) - E_y^n(i,j+1/2,k))/Delta z ]`.
- Na prática, o código repete essas atualizações para todas as células e componentes, aplica fontes, materiais, condutores e fronteiras, e registra sinais no tempo. Depois usa FFT para obter resposta em frequência, impedância, `S11`, padrão etc.
- `PML` significa Perfectly Matched Layer. O problema é que a grade computacional é finita, mas queremos simular espaço aberto. Se simplesmente pararmos a malha em uma parede, a onda reflete e volta, contaminando o resultado.
- A PML coloca ao redor do domínio uma camada artificial absorvente. A ideia é criar um meio matemático casado com o espaço interno: a onda entra na PML sem reflexão significativa na interface e, dentro dela, é atenuada progressivamente até desaparecer antes de chegar à borda externa.
- Uma forma intuitiva de ver a PML é como um “alongamento complexo” das coordenadas: em vez de a onda continuar propagando em espaço real, ela passa a acumular uma parte imaginária na constante de propagação, o que produz decaimento exponencial. Implementações práticas, como UPML/CPML, fazem isso introduzindo condutividades artificiais ou variáveis auxiliares graduais em cada direção.
- O perfil da PML precisa ser gradual. Se a absorção começa abruptamente, a própria transição causa reflexão. Por isso a condutividade artificial costuma crescer suavemente ao longo de várias células.
- PML não é mágica perfeita em computador real. Reflexões pequenas ainda ocorrem se a camada for fina demais, se a malha for grosseira, se a onda chegar em ângulo difícil, se houver campos evanescentes fortes perto da fronteira ou se a frequência estiver fora da faixa bem resolvida. Por isso mantemos a antena longe da PML e testamos convergência aumentando domínio, malha e espessura da camada.

## Slide 30 — MoM vs. FDTD: quando usar cada um?

- A diferença central é onde estão as incógnitas. No MoM/NEC, as incógnitas são correntes nos condutores; no FDTD, as incógnitas são campos `E` e `H` em todo o volume simulado. Isso muda completamente o custo e o tipo de problema natural para cada método.
- Para antenas de fios finos no ar, MoM costuma ser muito eficiente. Um dipolo, uma vertical com radiais ou uma Yagi podem ser descritos por centenas ou poucos milhares de segmentos, e o espaço aberto já entra pela função de Green `e^(-jkr)/r`. Não é preciso malhar todo o ar ao redor da antena.
- Para estruturas volumétricas, FDTD costuma ser mais natural. Patch antennas, substratos dielétricos, caixas, antenas impressas, conectores, radomes, materiais com perdas e geometrias 3D complexas exigem representar campos dentro e ao redor de volumes; aí a malha de Yee faz sentido.
- MoM no NEC2 é uma ferramenta de frequência única. Para varrer uma banda, o programa resolve o sistema em muitas frequências. Isso é ótimo quando cada solução é barata, como em Yagis de fios. FDTD excita com um pulso no tempo e depois usa FFT temporal nos sinais registrados; uma simulação pode dar resposta de banda larga, desde que a malha e o pulso cubram bem a faixa desejada.
- Por exemplo, o simulador registra `v(t)` e `i(t)` na porta; depois calcula `V(f)` e `I(f)` por FFT temporal e obtém `Z(f) = V(f)/I(f)` ou `S11(f)`. Também pode registrar campos `E(t)` e `H(t)` em pontos ou superfícies e transformar cada série temporal para obter campos em frequência.
- O custo do MoM clássico vem da matriz densa: memória `O(N^2)` e solução direta `O(N^3)`. Mas, em antenas de fio, `N` costuma ser pequeno. O custo do FDTD vem do volume: se dobramos a resolução em `x`, `y` e `z`, o número de células cresce por cerca de 8, e o passo de tempo também precisa diminuir, aumentando ainda mais o tempo total.
- Espaço aberto é outra diferença importante. No MoM de espaço livre, a condição de radiação já está embutida na função de Green. No FDTD, o computador sempre tem uma caixa finita; por isso precisamos de PML ou outra fronteira absorvente para impedir reflexões artificiais.
- O MoM de fio fino tem hipóteses fortes: condutores cilíndricos, finos em relação a `lambda`, segmentação adequada, materiais simples e geometrias sem detalhes volumétricos importantes. Ele pode errar se houver fita larga, placas, dielétricos próximos, conexões complexas, boom condutor modelado de forma grosseira ou correntes de modo comum no cabo não incluídas.
- O FDTD também tem armadilhas. A geometria fica “pixelizada” pela malha; condutores curvos ou muito finos podem ser mal representados se a célula for grande. Materiais dispersivos exigem modelos próprios. PML mal ajustada reflete. E resultados podem mudar bastante quando refinamos a malha, então teste de convergência é obrigatório.
- Para uma Yagi didática de fita de trena em 145 MHz, uma estratégia pragmática é usar NEC/PyNEC para projetar comprimentos e espaçamentos iniciais, construir, medir com NanoVNA e ajustar. Se a pergunta for “qual a influência exata da largura, curvatura e suporte da fita?”, aí FDTD ou outro solver com geometria 3D pode ser mais apropriado.
- Para uma antena de patch em FR-4, o caminho inverso vale: NEC2 não é a ferramenta certa, porque o dielétrico e os planos metálicos são parte essencial do problema. FDTD/OpenEMS ou um solver de elementos finitos/MoM de superfície é mais adequado.
- Para cabo coaxial, conectores, baluns, chokes e alimentação real, nenhum resultado deve ser aceito cegamente se esses elementos não foram modelados. Uma antena simulada como porta ideal balanceada pode se comportar diferente quando alimentada por coaxial real sem choke.
- A escolha de método também depende da pergunta. Para “qual comprimento do diretor maximiza frente-costas?”, MoM é excelente. Para “como o campo se acopla a uma caixa plástica com bateria e PCB perto da antena?”, FDTD é mais natural. Para “qual será a ROE real no protótipo?”, simulação ajuda, mas medição ainda fecha a conta.
- Em ambos os métodos, malha/segmentação não são detalhes burocráticos. No NEC, segmentos longos demais ou raio incompatível com o comprimento do segmento geram erro. No FDTD, células grandes demais distorcem velocidade de fase, ressonância e geometria. Sempre procure convergência: refine a discretização e veja se o resultado estabiliza.
- A mensagem prática do slide é que simulador não é oráculo. Ele resolve muito bem o modelo que você descreveu. Se o modelo omite cabo, mão, suporte, parafuso, solo, dielétrico, perdas ou curvatura, o resultado pode ser matematicamente correto e fisicamente incompleto.

## Slide 31 — Yagi-Uda: geometria

- Uma Yagi-Uda é um array endfire: vários elementos aproximadamente paralelos, alinhados sobre um boom, com o feixe principal apontando ao longo do eixo do boom. “Endfire” contrasta com “broadside”: em uma antena broadside, o máximo sairia perpendicular à linha do array; na Yagi, ele sai na direção dos diretores.
- O elemento ativo é o único diretamente alimentado pelo rádio. Ele define a porta elétrica da antena, mas não determina sozinho o padrão. O campo que ele irradia induz correntes no refletor e nos diretores, e a soma vetorial dos campos de todos os elementos forma o feixe.
- Refletor e diretores são chamados parasitas porque não recebem energia por cabo. Isso não significa que eles “atrapalhem” nem que sejam passivos irrelevantes: eles absorvem energia do campo próximo do ativo e a reirradiam com fase e amplitude determinadas por seu comprimento, espaçamento, diâmetro e perdas.
- O refletor é mais longo que o ativo para ficar eletricamente abaixo da própria ressonância na frequência de operação, com comportamento indutivo. Os diretores são mais curtos para ficarem acima da própria ressonância, com comportamento capacitivo. Essa diferença de reatância ajuda a produzir as fases necessárias para reforçar o campo para frente.
- O espaçamento típico `0,15--0,25 lambda` é compromisso. Elementos muito próximos acoplam fortemente, derrubam impedância e estreitam ajustes; elementos muito afastados acoplam pouco e deixam de produzir a fase/cancelamento desejados. Não há um único valor universal.
- “Progressivamente mais curtos” nos diretores é uma heurística comum, não uma lei rígida. Projetos otimizados podem usar diretores com variações pequenas, repetidas ou não monotônicas, dependendo de ganho, largura de banda, relação frente-costas e impedância desejados.
- A polarização da Yagi é definida pela orientação dos elementos. Elementos horizontais produzem polarização linear horizontal; elementos verticais produzem polarização vertical. Girar a antena em torno do boom muda a polarização, o que importa em satélites, repetidoras e enlaces ponto a ponto.
- O boom pode ser mecanicamente apenas suporte, mas eletromagneticamente pode importar se for metálico e conectado aos elementos. Elementos isolados do boom e elementos atravessando boom metálico não são exatamente a mesma antena; a montagem pode deslocar ressonâncias e exigir correção de comprimento.
- Para uma Yagi de fita de trena, a geometria real inclui elementos curvos e largos. O desenho ainda é Yagi, mas a construção não deve ser tratada como cópia perfeita de uma tabela de fios cilíndricos: medir e ajustar continua sendo parte do projeto.

## Slide 32 — Princípio: refletor indutivo, diretor capacitivo

- O ponto central é interferência controlada. Cada elemento reirradia um campo; em algumas direções esses campos somam, em outras cancelam. A Yagi funciona escolhendo comprimentos e espaçamentos para que a soma seja forte na frente e fraca atrás.
- O parasita se comporta como um ressonador forçado. Se ele é mais longo que a ressonância, sua impedância própria fica indutiva e a corrente induzida atrasa em relação ao campo excitador. Se é mais curto, fica capacitivo e a corrente adianta. Esse avanço/atraso entra na fase do campo reirradiado.
- O espaçamento adiciona outra fase: o campo do ativo leva tempo para chegar ao parasita, e o campo reirradiado pelo parasita leva tempo para chegar ao observador. Portanto, não basta dizer “refletor atrasa, diretor adianta”; a fase útil é a soma da fase elétrica do elemento com a fase geométrica de propagação.
- Atrás da antena, o refletor é ajustado para que sua reirradiação cancele parcialmente o campo do ativo. Na frente, a mesma fase que cancela atrás pode reforçar. Isso é a origem da relação frente-costas (`F/B`, front-to-back ratio).
- Diretores adicionais não simplesmente “puxam” a onda por mágica. Eles formam uma cadeia de elementos acoplados que favorece uma onda progressiva ao longo do boom. Quando bem ajustados, a radiação desses elementos se soma em fase na direção frontal.
- A intuição de “refletor mais comprido, diretor mais curto” é útil, mas projeto real é acoplado. Alterar o primeiro diretor muda a corrente no ativo, no refletor e nos demais diretores. Por isso otimização de Yagi costuma variar todos os comprimentos e espaçamentos em conjunto.
- O ganho, a impedância de entrada e a relação frente-costas competem entre si. Um ajuste que maximiza ganho pode piorar `SWR` ou `F/B`; um ajuste que maximiza `F/B` pode reduzir largura de banda. Projeto de Yagi é escolher compromisso, não buscar um único “ótimo” universal.
- Como as correntes são complexas, olhar só para comprimento físico pode enganar. O que realmente importa é amplitude e fase das correntes em cada elemento. Simuladores são úteis exatamente porque calculam essas correntes simultaneamente.

## Slide 33 — Ganho vs. boom e métodos de projeto

- Os números de ganho do slide são ordem de grandeza, não promessa de catálogo. Ganho real depende de diâmetro dos elementos, perdas, altura sobre o solo, boom, casamento, balun/choke, precisão mecânica e definição de referência usada pelo autor.
- A tendência robusta é que boom maior permite feixe mais estreito e maior ganho. Mas o ganho não cresce linearmente com número de elementos. Depois dos primeiros elementos, cada diretor extra traz retorno decrescente: mais comprimento, peso e sensibilidade mecânica para poucos dB adicionais.
- Um aumento de `3 dB` significa aproximadamente dobrar a potência radiada na direção principal, mas não significa dobrar o alcance de forma direta. Em espaço livre, dobrar alcance exige cerca de `6 dB` a mais no orçamento de enlace, porque perda de percurso cresce com o quadrado da distância.
- Relação frente-costas (`F/B`) mede quanto a antena rejeita a direção oposta ao feixe principal. Ela é importante para reduzir interferência, ruído e sinais indesejados atrás da antena, mas não é a mesma coisa que ganho. Uma Yagi pode ter bom ganho e `F/B` mediano, ou `F/B` excelente em uma faixa estreita.
- Largura de banda é outro critério. Yagis muito otimizadas para ganho ou `F/B` em uma frequência podem ficar estreitas: pequena mudança de frequência já altera impedância e padrão. Para uso em FM satélite ou faixa larga, às vezes vale sacrificar um pouco de ganho para obter comportamento mais robusto.
- A NBS Tech Note 688 é útil como ponto de partida porque fornece dimensões testadas/tabeladas para Yagis de vários comprimentos. Ela não substitui ajuste para material e construção reais, mas evita começar do zero.
- DL6WU é uma família de projetos/fórmulas muito usada para Yagis longas, especialmente em VHF/UHF. A utilidade está em dar uma geometria escalável com bom compromisso de ganho, impedância e largura de banda para booms maiores.
- Otimização numérica deve ter função objetivo clara. “Maximizar ganho” sozinho pode produzir antena difícil de casar ou com lóbulos laterais ruins. Objetivos mais realistas incluem ganho mínimo, `F/B`, `SWR < 2`, largura de banda, comprimento máximo de boom, separação mecânica mínima e tolerância a erros.
- Para uma antena didática, o melhor fluxo é: escolher projeto conhecido, simular com material aproximado, construir com folga para ajuste, medir `S11`/SWR, ajustar o elemento ativo ou casamento, e validar o padrão de forma simples em campo. Otimização extrema raramente é necessária para aprender e fazer contatos.

## Slide 34 — Casamento da Yagi à linha coaxial

- A impedância do elemento ativo isolado não é a mesma impedância do ativo dentro da Yagi. O refletor e os diretores acoplam energia de volta ao elemento alimentado e alteram a resistência e a reatância vistas no feedpoint.
- Por isso muitas Yagis com dipolo simples apresentam algo como `20--30 Omega` no feedpoint, mesmo que um dipolo meia-onda isolado no espaço livre fique perto de `73 Omega`. A impedância de entrada é uma propriedade do conjunto acoplado, não de um elemento sozinho.
- Casamento tem duas tarefas diferentes: transformar a parte real para perto de `50 Omega` e cancelar a parte imaginária. Uma antena com `25 - j30 Omega` não precisa apenas “subir de 25 para 50”; ela também precisa remover a reatância capacitiva.
- Dipolo dobrado aumenta a impedância porque divide corrente entre condutores paralelos e altera a relação tensão/corrente no ponto de alimentação. Em caso ideal com dois condutores iguais e isolados, a impedância é cerca de quatro vezes a de um dipolo simples equivalente. Em Yagi real, o valor final depende do acoplamento com parasitas.
- `Gamma match` é popular porque permite alimentar uma estrutura balanceada com coaxial desbalanceado e ajustar mecanicamente posição, comprimento e capacitância série. Ele não elimina automaticamente corrente de modo comum; um choke ainda pode ser necessário.
- `Beta match` ou `hairpin` é uma solução limpa quando o ativo é propositalmente curto e capacitivo. A hairpin fornece uma susceptância indutiva em paralelo que cancela a susceptância capacitiva e, ao mesmo tempo, transforma a resistência equivalente para perto de `50 Omega`.
- Transformador de quarto de onda é conceitualmente simples, mas exige linha com impedância característica adequada e comprimento elétrico correto. Em VHF/UHF isso pode ser viável; em HF pode ficar longo. A banda útil também é limitada porque a transformação depende de estar perto de `lambda/4`.
- Balun/choke não é apenas “acessório de capricho”. Se a alimentação real inclui coaxial, o cabo pode virar parte do sistema irradiante. Isso altera impedância medida, padrão, relação frente-costas e ruído recebido.
- Na prática, o casamento deve ser ajustado com a antena montada na configuração real: boom, suporte, cabo saindo na direção planejada, choke instalado, altura razoável do solo e elementos no material final. Ajustar uma Yagi em cima da mesa e depois levantá-la pode deslocar a frequência.

## Slide 35 — Como a hairpin match funciona

- A hairpin é mais fácil de entender em admitância, não em impedância. Como ela fica em paralelo com o ponto de alimentação, somamos admitâncias: `Y_total = Y_antena + Y_hairpin`.
- Se o ativo é encurtado, sua impedância fica `Z_A = R - jX_C`, ou seja, capacitiva. A admitância correspondente tem parte imaginária positiva ou negativa dependendo da convenção, mas a ideia física é que há susceptância capacitiva a ser cancelada por uma susceptância indutiva da hairpin.
- O stub curto-circuitado menor que `lambda/4` apresenta comportamento indutivo na entrada. Em uma aproximação de linha sem perdas, a impedância de entrada de um stub curto é `Z_stub = j Z0 tan(beta l)`. Para `l << lambda/4`, `tan(beta l) approx beta l`, então ele parece um indutor pequeno.
- O valor de `X_L` depende do comprimento da hairpin, separação entre as hastes, diâmetro dos condutores e ambiente próximo. Aproximar como linha paralela ajuda, mas o ajuste final costuma ser experimental.
- Exemplo do slide: se a antena curta apresenta `25 - j30 Omega`, a rede em paralelo pode ser escolhida para cancelar a parte reativa na admitância total e deixar a resistência equivalente perto de `50 Omega`. O resultado não é obtido somando `+j30` em série; é uma soma em paralelo, por isso a conta deve ser feita em `Y`.
- A hairpin também pode melhorar a robustez mecânica: é feita de barra ou fio rígido, sem capacitor variável exposto. Isso é atraente para antena portátil, de campo ou feita por alunos.
- A desvantagem é que os ajustes interagem. Mudar o comprimento do elemento ativo muda `R` e `X_C`; mudar a hairpin muda o casamento; mudar o espaçamento da hairpin muda sua impedância característica. O procedimento prático é aproximar por simulação/tabela e depois ajustar medindo `S11`.
- A hairpin não substitui o choke. Ela resolve casamento diferencial no ponto de alimentação; corrente de modo comum no exterior do coaxial é outro problema.
- Em uma Yagi de fita de trena, a dobra, o grampo e a conexão elétrica no ponto de alimentação podem ser parte relevante da hairpin/casamento. Mau contato ou assimetria mecânica aparece como variação de impedância e instabilidade na medição.

## Slide 36 — Baluns: sem eles, o casamento mente

- O modo desejado no coaxial é diferencial: corrente vai pelo condutor interno e volta pela face interna da malha. Idealmente, o campo fica confinado entre interno e malha, e o exterior do cabo não participa da antena.
- Um dipolo ou Yagi com elemento ativo simétrico é uma carga balanceada: os dois braços deveriam ter correntes iguais em magnitude e opostas em fase. Quando conectamos coaxial diretamente, a malha tem duas faces eletricamente distintas em RF: a face interna, que faz parte da linha, e a face externa, que pode conduzir corrente de modo comum.
- Corrente de modo comum no exterior da malha significa que o cabo virou um terceiro braço da antena. Isso muda o padrão, pode reduzir `F/B`, altera a impedância medida e leva RF para perto do rádio, computador, operador e cabos USB.
- A frase “o casamento mente” significa que o NanoVNA pode mostrar `SWR` bom para o sistema antena+cabo+ambiente, não para a antena sozinha. Ao mexer no cabo, a impedância muda; isso é sinal clássico de modo comum.
- Um choke balun não necessariamente transforma impedância. Ele apresenta alta impedância para corrente de modo comum e baixa perturbação para o modo diferencial. Por isso o nome mais preciso muitas vezes é `common-mode choke`.
- Um current balun 1:1 tenta forçar correntes iguais e opostas nos dois terminais balanceados. Isso é diferente de um voltage balun, que força tensões simétricas; em muitas antenas reais, current balun/choke é preferível porque ataca diretamente a corrente indesejada.
- Um balun 4:1 combina duas funções quando bem projetado: transforma impedância e faz transição balanceado-desbalanceado. Ele é útil com dipolo dobrado ou cargas balanceadas de impedância mais alta, mas não deve ser usado apenas porque “balun é sempre 4:1”.
- Um choke não precisa ser um transformador com relação de voltas `1:1`. A implementação mais simples é uma impedância de modo comum em série com o lado externo do coaxial, sem interromper o modo diferencial interno. Para o sinal desejado dentro do coaxial, o cabo continua sendo uma linha de transmissão; para a corrente no exterior da malha, o conjunto parece um indutor/perda em série.
- Opção 1: bobina de coaxial no ar, também chamada ugly balun ou air-core choke. Enrola-se o próprio cabo coaxial em várias espiras, com diâmetro e número de voltas escolhidos para a banda. Em HF pode funcionar bem em faixa estreita; em VHF/UHF costuma ser menos previsível porque a bobina entra em autorressonância e a capacitância entre espiras fica relevante. Construção típica: 5 a 10 espiras de coaxial em um tubo de PVC ou forma plástica, fixadas mecanicamente, colocadas perto do feedpoint.
- Opção 2: ferrites tipo bead ou snap-on no coaxial. Passa-se o cabo por dentro de vários núcleos de ferrite, ou prende-se vários ferrites bipartidos ao redor do cabo. O modo diferencial quase não enxerga o ferrite, porque os campos do condutor interno e da face interna da malha se cancelam externamente; o modo comum, que circula pela parte externa da malha, enxerga alta impedância. Construção típica: empilhar várias contas de ferrite no coaxial junto à antena, ou usar vários snap-ons adequados à faixa.
- Opção 3: coaxial dando voltas em um toróide de ferrite. Em vez de apenas passar reto por beads, enrola-se o coaxial inteiro por dentro de um toróide várias vezes. Cada passagem pelo furo conta como uma volta para o modo comum. Isso aumenta a impedância aproximadamente com `N^2`, até parasitas e saturação/perdas limitarem. Construção típica em HF: 5 a 12 voltas de RG-58/RG-316/RG-400 em um ou mais toróides de material adequado, com cuidado para não esmagar o cabo nem exceder raio mínimo de curvatura.
- Opção 4: choke com linha bifilar ou par trançado em ferrite, usado como current balun 1:1 tipo Guanella. Dois condutores isolados formam uma linha de transmissão balanceada enrolada em núcleo de ferrite; uma ponta vai ao coaxial desbalanceado, a outra aos terminais balanceados da antena. Para o modo diferencial, a energia passa pela linha; para modo comum, o núcleo apresenta alta impedância. Construção típica: enrolar duas linhas paralelas ou par trançado em toróide, ligar entrada a conector coaxial e saída aos dois braços do dipolo/Yagi.
- Opção 5: sleeve balun ou bazooka em VHF/UHF. É uma luva condutora de aproximadamente `lambda/4`, conectada à malha do coaxial em uma extremidade e aberta na outra, formando uma alta impedância para corrente no exterior da malha na frequência de projeto. Construção típica: tubo metálico ou malha adicional ao redor do coaxial perto do feedpoint, com comprimento elétrico de quarto de onda considerando o fator de velocidade/geométrico.
- Opção 6: balun 4:1 ou 1:1 de transmissão em ferrite. Um 1:1 pode ser apenas choke/current balun; um 4:1 normalmente usa duas linhas de transmissão em ferrite na configuração Guanella para transformar impedância mantendo bom isolamento de modo comum. Construção típica de 4:1 Guanella: duas seções idênticas de linha bifilar enroladas em ferrites, ligadas em paralelo no lado de 50 ohms e em série no lado de 200 ohms. Isso é diferente de um autotransformador simples de tensão, que pode transformar impedância mas bloquear pior o modo comum.
- A escolha do ferrite depende da faixa. Materiais usados em HF, VHF e UHF têm permeabilidade e perdas diferentes. Um núcleo ótimo para 3--30 MHz pode não funcionar bem em 145 MHz; em VHF, muitas vezes beads/snap-ons específicos ou poucas voltas são melhores que muitas voltas em toróide grande.
- A posição também importa: para impedir que o cabo vire parte da antena, o choke deve ficar no feedpoint ou o mais próximo possível dele. Um choke só no shack pode reduzir RF entrando no equipamento, mas não impede que o trecho de coaxial entre antena e shack irradie ou receba como parte da antena.
- Chokes de ferrite dependem da frequência. Um conjunto excelente em HF pode ser fraco em VHF; uma bobina de coaxial no ar pode funcionar em uma banda e ressonar mal em outra. Escolha de material de ferrite, número de voltas, diâmetro e montagem importa.
- Verificar choke por `S21` mede quanto sinal de modo comum atravessa o dispositivo no arranjo de teste. Atenuação de `25 dB` significa que a corrente/onda de modo comum foi bastante reduzida na banda, mas a montagem de medição precisa representar o modo comum corretamente.
- Mesmo quando a antena “funciona sem balun”, usar choke melhora repetibilidade: a ROE depende menos da posição do cabo, o padrão fica mais parecido com o projeto e a recepção pode ficar menos ruidosa.

## Slide 37 — NanoVNA: o que ele mede

- `VNA` significa Vector Network Analyzer. “Vector” é a parte importante: ele mede amplitude e fase. Um medidor de ROE simples mede essencialmente magnitudes; o VNA mede o coeficiente de reflexão complexo e, a partir dele, calcula impedância, fase, Smith, `SWR` e outros formatos.
- Parâmetros `S` são parâmetros de espalhamento. Eles relacionam ondas incidentes e ondas que saem das portas de uma rede RF, todas normalizadas a uma impedância de referência, normalmente `50 Omega`. Para uma rede de duas portas, escrevemos `b1 = S11 a1 + S12 a2` e `b2 = S21 a1 + S22 a2`, onde `a` são ondas incidentes e `b` são ondas que saem/refletem das portas.
- Portanto, `S11` não é diretamente “porcentagem de potência refletida”; ele é um coeficiente complexo de amplitude de onda normalizada, com módulo e fase. Quando a porta de referência é real e igual nas ondas incidente/refletida, a fração de potência refletida é `|S11|^2`. Assim, `|S11| = 0,1` significa 10% da amplitude de onda refletida e 1% da potência refletida.
- Também não é exatamente “amplitude do campo elétrico” no espaço livre. Em linhas e portas RF, os parâmetros `S` usam ondas de potência normalizadas, derivadas de tensão e corrente na porta. Em uma linha de `50 Omega`, isso se comporta como amplitude de onda viajante; a potência é proporcional ao quadrado do módulo.
- `S11` é reflexão vista na porta 1. No NanoVNA, `CH0/REFL` injeta sinal no dispositivo sob teste (`DUT`, device under test) e mede a onda que retorna à mesma porta. Para antenas, `S11` é a medida principal, porque queremos saber como a antena aparece para a linha de `50 Omega`.
- `S21` é transmissão da porta 1 para a porta 2: onda que sai pela porta 2 dividida pela onda incidente na porta 1, com a porta 2 terminada na referência. Ele serve para medir filtros, atenuadores, cabos, traps, chokes em arranjos de teste, amplificadores passivos/ativos dentro dos limites do instrumento e resposta de duas portas.
- O NanoVNA calcula impedância a partir de `Gamma = S11` usando `Z = Z0 (1 + Gamma)/(1 - Gamma)`, normalmente com `Z0 = 50 Omega`. Se a calibração estiver errada ou o plano de referência estiver no lugar errado, a impedância calculada também estará errada.
- `Return loss` é `-20 log10 |S11|`. Se `|S11| = 0,1`, o return loss é `20 dB`, e a potência refletida é `|S11|^2 = 1%`. Return loss maior é melhor; isso confunde alunos porque `S11` em dB aparece como número negativo, por exemplo `-20 dB`.
- `-13 dBm` é cerca de `0,05 mW`. O NanoVNA emite sinal muito fraco, suficiente para medir passivos próximos, não para transmitir. Justamente por ter entrada sensível, ele pode ser danificado por RF externo de transmissores próximos, antenas ativas, descargas eletrostáticas ou DC aplicada por engano.
- A faixa acima da fundamental deve ser tratada com cautela. Em alguns modelos, acima de certa frequência o instrumento usa harmônicas do oscilador; ainda pode ser útil, mas dinâmica, pureza espectral e precisão podem piorar. Para aula e antenas VHF/UHF simples, ele é excelente se calibrado e usado com cuidado.
- O VNA mede o sistema conectado. Se a antena está ligada por cabo, sem calibrar na ponta do cabo, você mede antena transformada pelo cabo. Se o cabo tem corrente de modo comum, você mede antena+cabo+ambiente.

## Slide 38 — Carta de Smith aplicada

- A Carta de Smith é o plano do coeficiente de reflexão `Gamma` redesenhado com linhas de resistência e reatância constantes. Ela parece misteriosa, mas é apenas uma forma gráfica de converter entre `Gamma` e impedância normalizada `z = Z/Z0`.
- Normalizar por `Z0` significa dividir a impedância pelo sistema de referência. Em um sistema de `50 Omega`, `Z = 50 + j0` vira `z = 1 + j0`, que é o centro da carta.
- O centro é casamento perfeito porque `Gamma = 0`: não há onda refletida. A borda externa representa `|Gamma| = 1`: reflexão total em uma carga puramente reativa, aberta ou em curto ideal, sem potência média entregue à carga.
- O lado direito é aberto porque `Z -> infinity` produz `Gamma -> +1`. O lado esquerdo é curto porque `Z = 0` produz `Gamma = -1`. Entre eles, o eixo horizontal representa impedâncias puramente resistivas.
- A metade superior é indutiva (`X > 0`) e a metade inferior é capacitiva (`X < 0`) para a convenção usual de impedância. Isso é muito útil no ajuste: se o traço da antena está abaixo do eixo na frequência-alvo, ela está capacitiva; se está acima, está indutiva.
- Cruzar o eixo horizontal significa `X = 0`, ou seja, ressonância da porta. Isso não significa automaticamente casamento. O cruzamento pode ocorrer em `25 + j0 Omega`, `73 + j0 Omega` ou `200 + j0 Omega`; todos são ressonantes, mas só `50 + j0 Omega` está casado com sistema de 50 ohms.
- Ao varrer frequência, a antena desenha uma trajetória. Para um dipolo perto da primeira ressonância, abaixo da ressonância ele costuma parecer capacitivo; acima, indutivo. Isso dá uma regra prática: ressonância acima da frequência desejada indica antena curta; ressonância abaixo indica antena longa.
- A Carta de Smith também mostra por que usar apenas `SWR` pode esconder informação. Dois pontos em lados opostos do centro podem ter o mesmo `|Gamma|` e o mesmo `SWR`, mas exigir correções opostas: um precisa de compensação indutiva, outro capacitiva.
- Perto da borda da carta, pequenas mudanças de fase ou cabo podem produzir grandes mudanças de impedância aparente. Por isso medições de cargas muito descasadas são mais sensíveis a calibração, adaptadores e cabos.

## Slide 39 — Calibração SOLT/OSLT com o cabo

- Calibração não é um ritual opcional; ela define o plano de referência. Antes da calibração, o NanoVNA mede sua própria porta, conectores, cabos, adaptadores e erros internos misturados com o dispositivo sob teste.
- `SOLT` significa Short, Open, Load, Thru. `OSLT` é a mesma sequência em outra ordem. Para medir uma porta (`S11`), usamos open, short e load. Para duas portas (`S21`), também usamos isolation e thru.
- `Open` apresenta reflexão quase `+1`; `Short` apresenta reflexão quase `-1`; `Load` ideal de `50 Omega` apresenta `Gamma = 0`. Com esses três padrões, o VNA estima e remove erros sistemáticos de reflexão: directivity, source match e tracking.
- `Thru` conecta a porta 1 à porta 2 e define a referência de transmissão. `Isolation` mede vazamento entre canais quando não deveria haver transmissão. Esses passos importam quando medimos filtros, cabos, chokes e atenuadores por `S21`.
- Calibrar com o cabo conectado move o plano de referência para a ponta distante do cabo. Isso remove a transformação de impedância do cabo e permite que a impedância mostrada corresponda ao que está conectado na ponta.
- Se você calibra na porta do VNA e depois conecta um cabo até a antena, o cabo passa a fazer parte do DUT. Isso pode ser desejado se você quer medir “o sistema como o rádio enxerga”, mas é errado se você quer saber a impedância real no feedpoint.
- Adaptadores depois da calibração estragam a referência. Se calibrar em SMA e depois colocar SMA-BNC, rabicho, jacaré ou adaptador UHF, tudo isso entra na medição. Para precisão, calibre com todos os adaptadores que ficarão antes do plano de medição.
- Os padrões baratos do NanoVNA não são ideais em todas as frequências. Em VHF costumam ser bons o suficiente para aula e ajuste prático; em UHF, parasitas dos padrões e adaptadores começam a importar mais. Repetir calibração na faixa estreita de interesse melhora o resultado.
- Salvar a calibração só é válido para a mesma faixa de frequência, número de pontos, cabos e adaptadores. Se mudar a varredura ou o cabo, refaça a calibração.
- Uma checagem simples depois de calibrar é reconectar a carga `50 Omega`: o ponto deve ficar perto do centro da Smith e `SWR` perto de `1:1`. Se não ficar, algo está errado com calibração, padrão, cabo ou conector.

## Slide 40 — Medindo antena: ressonância não é casamento

- Ressonância é condição de reatância nula na porta: `X = 0`. Casamento é condição de impedância igual à referência do sistema, normalmente `Z = 50 + j0 Omega`. Uma antena pode estar ressonante e descasada, ou casada por rede externa e não estar ressonante por si só.
- Exemplo: um dipolo meia-onda livre pode estar em `73 + j0 Omega`. Ele está ressonante, mas em sistema de `50 Omega` tem `SWR approx 1,46`. Uma Yagi pode estar em `25 + j0 Omega`: também ressonante, mas com `SWR = 2:1`.
- O primeiro ajuste mecânico geralmente é levar a ressonância para a frequência alvo. Se a ressonância aparece acima da frequência desejada, a antena está eletricamente curta; aumentamos comprimento. Se aparece abaixo, está longa; encurtamos.
- Depois de colocar `X = 0` perto da frequência alvo, ajustamos casamento. Isso pode envolver hairpin, gamma, transformador de quarto de onda, posição de alimentação, dipolo dobrado, balun ou alteração controlada da geometria.
- Fazer na ordem inversa costuma confundir. Uma rede de casamento pode produzir `SWR` bom em uma frequência enquanto a antena física ainda está curta ou longa. O resultado pode funcionar, mas fica estreito, sensível e difícil de diagnosticar.
- No NanoVNA, a frequência de menor `SWR` nem sempre coincide exatamente com `X = 0`. O mínimo de `SWR` ocorre quando `Z` chega mais perto de `50 + j0`; a ressonância ocorre no cruzamento do eixo real da Smith. Essas são condições diferentes.
- Para antenas próximas ao solo, ao corpo ou a objetos, a ressonância medida pode mudar ao levantar a antena para a posição real. Em VHF/UHF, a mão, o cabo e o suporte já podem deslocar a medição; por isso o choke e a geometria de teste importam.
- Em antenas com múltiplas ressonâncias, como loops, multibandas e estruturas carregadas, “o cruzamento de `X = 0`” precisa ser interpretado junto com padrão, impedância e faixa de uso. Nem toda ressonância é o modo desejado.

## Slide 41 — TDR: comprimento do cabo e descontinuidades

- `TDR` significa Time-Domain Reflectometry. A ideia clássica é enviar um pulso ou degrau em uma linha e observar reflexões no tempo. O tempo de retorno indica distância; o sinal da reflexão indica se a descontinuidade parece mais aberta, curta, capacitiva ou indutiva.
- O NanoVNA não gera necessariamente um pulso ultrarrápido diretamente. Ele mede `S11` em muitas frequências e usa uma transformada inversa (`IFFT`) para sintetizar uma resposta no domínio do tempo. É uma forma de TDR por processamento de frequência.
- A distância vem do tempo de ida e volta. Se a reflexão aparece em tempo `t`, a distância é aproximadamente `d = v_p t/2 = VF * c * t/2`. Divide-se por 2 porque o sinal foi até a descontinuidade e voltou.
- O `velocity factor` precisa estar correto. Se você usar `VF = 0,66` para um cabo foam que tem `VF = 0,82`, o comprimento estimado ficará errado na mesma proporção.
- `LOW_PASS_IMPULSE` mostra picos associados a descontinuidades. É bom para localizar conectores, emendas, dano, fim do cabo e mudanças bruscas. `LOW_PASS_STEP` se parece mais com uma leitura de impedância acumulada ao longo do cabo.
- Ponta aberta produz reflexão positiva forte; ponta em curto produz reflexão negativa forte. Uma carga casada ideal no fim do cabo quase não reflete, então o fim pode desaparecer no TDR se estiver bem terminado.
- A resolução espacial depende da largura de banda medida. Regra de intuição: quanto maior a frequência máxima e a largura de banda, mais estreito é o pulso sintetizado e melhor a separação entre descontinuidades próximas. Cabos muito curtos ou defeitos muito próximos podem se fundir em um único pico.
- O número de pontos também importa. Poucos pontos causam janelas temporais e resolução piores; softwares no PC com mais pontos podem mostrar detalhes que o display interno do NanoVNA não mostra.
- A estimativa de perda do cabo com ponta aberta usa a reflexão que foi até o fim e voltou. Se o módulo de `S11` aparece, por exemplo, `-6 dB` com ponta aberta ideal, isso corresponde a cerca de `3 dB` de perda em um sentido, porque o sinal percorreu o cabo duas vezes.
- Essa estimativa é aproximada. Conectores, padrões não ideais, radiação, descasamentos intermediários e frequência dependente da perda podem alterar a leitura. Para medição séria de perda, medir `S21` com duas portas e calibração adequada é melhor.

## Slide 42 — Medindo `Z0` do cabo pelo método `lambda/8`

- O método não é destrutivo e não exige cortar o cabo em `lambda/4` nem em `lambda/8`. Usa-se um pedaço de cabo qualquer, de comprimento fixo, com a ponta distante aberta. O que muda é a frequência da medição: ao varrer a frequência, aquele mesmo comprimento físico passa a representar diferentes comprimentos elétricos.
- O método funciona porque uma linha sem perdas terminada em aberto tem impedância de entrada `Z_in = -j Z0 cot(beta l)`. Quando `l = lambda/8`, `beta l = pi/4`, e `cot(pi/4) = 1`; portanto `Z_in = -j Z0` e `|Z_in| = Z0`.
- Primeiro achamos a frequência em que o cabo aberto parece curto na entrada. Isso ocorre em `l = lambda/4`, porque `cot(pi/2) = 0`, então `Z_in` vai para zero idealmente. Na Smith, o ponto vai para a esquerda.
- Metade dessa frequência corresponde a `l = lambda/8` para o mesmo cabo físico, assumindo que `VF` não mudou muito com a frequência. Nessa frequência, basta ler `|Z|`; idealmente ele é igual a `Z0`.
- Não há dobra especial nem alteração física do cabo. “`lambda/4`” e “`lambda/8`” descrevem o comprimento elétrico que o cabo já existente tem em duas frequências diferentes. Se o cabo tem comprimento físico `l`, primeiro encontramos a frequência em que `l = lambda_cabo/4`; depois medimos em metade dessa frequência, onde `l = lambda_cabo/8`.
- O método é útil para identificar cabo desconhecido: distinguir `50 Omega` de `75 Omega`, verificar cabo antigo, ou confirmar se um pedaço de coaxial encontrado na bancada é RG-58/RG-59/RG-11 etc.
- A ponta aberta precisa estar realmente aberta e limpa. Adaptadores, jacarés, emendas e capacitância parasita na extremidade podem deslocar a leitura, principalmente em cabos curtos ou frequências altas.
- O cabo deve ter comprimento suficiente para que a primeira condição de `lambda/4` ocorra dentro da faixa útil do NanoVNA. Cabo curto demais empurra `f_lambda/4` para frequência alta, onde o instrumento e os padrões podem ser menos precisos.
- Perdas no cabo arredondam os extremos. O aberto não aparece como aberto perfeito, o curto transformado não chega exatamente a zero, e `|Z|` em `lambda/8` pode desviar um pouco. Ainda assim, para cabos comuns e aula prática, o método é bastante bom.
- A variante com aberto e curto procura o ponto em que as curvas de `|Z|` se cruzam. Ela ajuda a reduzir alguns erros porque aberto e curto têm transformações complementares na linha.
- Não confunda `Z0` com a impedância medida em uma frequência qualquer. Um cabo de `50 Omega` aberto pode mostrar impedâncias enormes, pequenas, capacitivas ou indutivas dependendo do comprimento elétrico. `Z0` é a propriedade da linha viajante; o método `lambda/8` é uma forma esperta de extraí-la da transformação.

## Slide 43 — Chokes, traps e filtros via `S21`

- `S21` mede transmissão de uma porta para outra. Em dispositivo passivo, `S21` em dB negativo indica perda de inserção ou atenuação. Um filtro passa-faixa tem `S21` perto de `0 dB` na passagem e muito negativo na rejeição.
- Para medir `S21` direito, a calibração de duas portas importa. `Thru` remove perda/fase do caminho de referência; `Isolation` estima vazamento interno entre canais; `Open/Short/Load` corrigem reflexões nas portas.
- Choke de modo comum não deve ser medido como se fosse apenas um pedaço de cabo em modo diferencial. O objetivo é medir a impedância ou atenuação vista pela corrente de modo comum no exterior do coaxial. Por isso o arranjo de ensaio curto-circuita vivo e malha juntos em cada ponta, formando uma porta comum.
- O arranjo de `S21` para choke de coaxial é assim: em uma extremidade do choke, una condutor interno e malha; esse nó vai ao pino central da porta `CH0`. Na outra extremidade, una também condutor interno e malha; esse nó vai ao pino central da porta `CH1`. As blindagens dos cabos de teste do VNA ficam como retorno comum do instrumento/fixture; não devem ser ligadas de modo a bypassar o choke pelas malhas externas. O que atravessa o choke entre os dois pinos centrais é uma corrente de modo comum, pois vivo e malha do coaxial sob teste caminham juntos no mesmo sentido.
- Outra forma de medir é como impedância de uma porta: una vivo+malha em uma ponta do choke e conecte esse nó ao centro de `CH0`; una vivo+malha na outra ponta e conecte ao terra/blindagem de `CH0`. A impedância lida é uma aproximação da impedância série de modo comum do choke. O método de duas portas com `S21` é mais comum para visualizar atenuação ao longo da frequência.
- Atenuação de modo comum em `S21` não é exatamente a mesma coisa que impedância de modo comum em ohms, mas é uma medida prática da eficácia na banda. Uma atenuação de `25 dB` já indica que o choke dificulta bastante a passagem da corrente indesejada.
- O choke pode ter ressonâncias. Em uma frequência ele pode apresentar alta impedância; em outra, capacitância parasita entre voltas pode criar caminho alternativo e reduzir a eficácia. Por isso é necessário medir na banda de uso, não apenas “contar voltas”.
- Objetos metálicos, suporte, proximidade do boom e curvatura do cabo podem deslocar a resposta de um choke. Se o choke vai ficar perto da antena ou preso ao boom, medir em ambiente parecido é mais confiável.
- Um trap é um circuito ressonante inserido em uma antena para mudar seu comprimento elétrico conforme a frequência. O caso clássico é um `LC` paralelo colocado em série com um elemento de fio: na frequência de ressonância do trap, sua impedância fica alta e ele quase “abre” o fio naquele ponto; em frequências mais baixas, ele deixa a corrente passar de forma diferente e permite que o restante do fio participe.
- Em antenas multibanda, isso permite que a mesma antena pareça curta em uma banda alta e mais longa em uma banda baixa. Exemplo conceitual: em um dipolo para 40/20 m, o trap ressonante em 20 m isola a parte externa do fio em 20 m; em 40 m, a corrente atravessa o trap e usa o comprimento total.
- Trap LC paralelo funciona como alta impedância na frequência de ressonância. Medindo `S21` através dele, a ressonância aparece como um entalhe: a transmissão cai porque o trap bloqueia aquela frequência.
- `Q` do trap aparece na largura do entalhe. Entalhe estreito e profundo indica `Q` alto; entalhe largo e raso indica perdas maiores. Trap com baixo `Q` pode aquecer, reduzir eficiência e alterar a largura de banda da antena.
- Filtros e duplexadores exigem cuidado com faixa dinâmica. Se o NanoVNA tem faixa dinâmica útil de `70--80 dB`, ele pode mostrar bem filtros simples, mas não consegue validar com confiança rejeições de `90--100 dB` exigidas em duplexadores de repetidora.
- Em medições de rejeição alta, cabos, adaptadores e vazamento externo podem dominar. Às vezes o sinal “passa” pelo ar entre portas ou pelo layout da bancada, não pelo dispositivo. Blindagem, cargas boas e montagem física importam.

## Slide 44 — Simulação e medida: faces do mesmo fenômeno

- Simulação e medição devem responder à mesma pergunta e usar o mesmo plano de referência. Se a simulação dá `Z_A` no feedpoint, mas o NanoVNA mede na ponta de um cabo sem calibração, a comparação será injusta.
- A ponte matemática é `S11` e impedância. O simulador calcula `Z_A(f)`. A partir dela, podemos calcular `Gamma(f) = (Z_A - Z0)/(Z_A + Z0)` e comparar com o `S11(f)` medido. Ou o inverso: converter `S11` medido para `Z_in = Z0(1+S11)/(1-S11)`.
- A curva `.s1p` é um arquivo Touchstone de uma porta. Ele guarda frequência e `S11` complexo. Isso permite comparar no computador a medida real com a simulação, aplicar de-embedding, plotar Smith e calcular métricas.
- De-embedding é remover matematicamente da medição uma rede conhecida que está entre o instrumento e o dispositivo que realmente queremos medir. Exemplo: se o VNA mediu `cabo + adaptador + antena`, e conhecemos os parâmetros do cabo/adaptador, podemos “descontar” essa rede para estimar o `S11` que existiria no feedpoint da antena.
- Conceitualmente, é uma mudança de plano de referência feita por cálculo. Em vez de calibrar fisicamente na ponta do cabo, medimos ou modelamos o cabo como uma rede de duas portas e removemos sua matriz da cascata. Funciona bem quando essa rede intermediária é linear, estável e bem caracterizada; se há modo comum, mau contato ou cabo se mexendo, o de-embedding vira aproximação frágil.
- Discrepância não significa automaticamente que o simulador está errado. Pode significar que o modelo esqueceu o cabo, choke, conector, boom, fita larga, parafuso, solo, mão, parede, dielétrico, perdas ou tolerância de construção.
- Discrepância também pode vir da medição: calibração no plano errado, carga de calibração ruim, conector frouxo, adaptador depois da calibração, faixa larga demais, poucos pontos, RF externa ou corrente de modo comum.
- Uma boa prática é comparar primeiro características robustas: frequência de ressonância, ordem de grandeza de resistência, tendência capacitiva/indutiva e largura aproximada. Só depois faz sentido cobrar coincidência fina de `SWR` ou `F/B`.
- Corrente simulada ajuda a diagnosticar. Se o NEC mostra corrente alta no refletor ou no primeiro diretor, isso explica sensibilidade mecânica. Se a medição mostra ressonância deslocada, olhar distribuição de corrente ajuda a decidir qual elemento ajustar.
- Ferrites são difíceis no NEC clássico porque envolvem materiais magnéticos, perdas e dispersão. Um choke real pode ser medido por `S21` e inserido no raciocínio como componente externo, mesmo que a antena de fios seja simulada no NEC.
- A filosofia correta é iterativa: simular para entender, construir para revelar o que foi omitido, medir para corrigir, atualizar o modelo se necessário e só então otimizar.

## Slide 45 — Armadilhas comuns na prática

- Cabo sem calibração é a armadilha mais comum. A impedância no rádio pode ser uma versão transformada da impedância da antena. Isso explica situações em que trocar o comprimento do cabo “melhora” a ROE sem melhorar a antena.
- Remover ou trocar a ponta do cabo após calibrar muda o plano de referência. Se a calibração incluía um rabicho específico e ele é substituído por outro, a correção deixa de representar o sistema real.
- Corrente de modo comum pode fazer a medição depender da posição do cabo, da mão e da bancada. Um teste simples é mexer no cabo mantendo a antena imóvel: se a curva muda muito, o cabo está participando da antena.
- Fator de velocidade errado em TDR gera erro proporcional no comprimento. Se o VF real é `0,80` e você usa `0,66`, a distância estimada fica cerca de 17% baixa.
- Potência baixa do NanoVNA é vantagem para segurança, mas limita medidas de dispositivos muito atenuantes. Se o sinal refletido ou transmitido cai perto do piso de ruído, o instrumento pode mostrar uma curva bonita e falsa.
- Cabo “50 ohms” real não é exatamente 50 ohms. Variação de fabricação, envelhecimento, umidade, esmagamento e conectores criam pequenas descontinuidades. `SWR 1,02` vs `1,05` raramente é relevante em antena prática.
- DC na porta pode queimar o NanoVNA porque as portas não são entradas universais de multímetro. Se houver chance de bias, alimentação remota, LNA, bias-tee, transmissor ou carga ativa, use DC block e confirme antes.
- RF externa também é risco. Não meça antena conectada se há transmissor próximo em operação ou se o próprio rádio pode transmitir acidentalmente para dentro do VNA. A potência tolerável é muito menor que a potência de um HT.
- Carga de calibração desgastada ou aquecida deixa de ser `50 Omega`. Se a carga caiu, oxidou, afrouxou ou foi usada com potência alta, vale conferir contra outra carga conhecida.
- A máxima prática é separar diagnóstico em perguntas: onde está a ressonância? qual é a resistência nesse ponto? há modo comum? a calibração está no plano certo? o cabo está incluído ou removido da medida? Sem essa separação, tudo vira “SWR ruim” e a correção vira tentativa e erro.

## Slide 46 — Link budget: equação de Friis e FSPL

- Um link budget é uma contabilidade em dB de tudo que aumenta ou reduz potência útil entre transmissor e receptor. A vantagem do dB é transformar multiplicações em somas: potência, ganhos e perdas entram como termos aditivos.
- A equação de Friis vale no campo distante, em espaço livre, com antenas alinhadas, polarização compatível e sem multipercurso relevante. Ela é uma referência ideal; enlaces reais acrescentam perdas de apontamento, polarização, atmosfera, chuva, cabos e margem.
- `FSPL` não é energia “absorvida pelo espaço”. É perda geométrica: a mesma potência se espalha por uma esfera cada vez maior. O receptor captura só uma fração dessa esfera por sua abertura efetiva.
- A forma `20 log10(d)` aparece porque densidade de potência cai com `1/d^2`, e potência em dB usa `10 log10`. Assim, dobrar a distância aumenta a perda em cerca de `6 dB`.
- A forma `20 log10(f)` aparece porque, para antenas de mesmo ganho, a abertura efetiva é proporcional a `lambda^2`. Em frequência maior, `lambda` menor, a abertura efetiva para o mesmo ganho é menor. Cuidado: se compararmos antenas de mesma área física, a interpretação muda.
- A constante `32,45` vale quando `d` está em km e `f` em MHz. Ela não é uma constante física misteriosa; vem de `4 pi`, velocidade da luz e conversão de unidades.
- `G_t` e `G_r` devem estar na mesma referência, normalmente dBi. Misturar dBd e dBi causa erro de `2,15 dB` por antena.
- Perdas de linha entram antes ou depois dos ganhos conforme a cadeia física. No TX, potência sai do rádio, perde no cabo, depois ganha na antena. No RX, a antena ganha, depois a linha perde antes do receptor. Em dB, a ordem conceitual ajuda a não esquecer termos.
- Friis calcula potência recebida na entrada do receptor ou no ponto escolhido da cadeia. É essencial definir o plano: saída do transmissor, feedpoint da antena, entrada do LNA, entrada do demodulador etc.

## Slide 47 — PIRE/EIRP e cadeia do transmissor

- `EIRP` ou `PIRE` é potência isotrópica radiada equivalente. Ela pergunta: “qual potência uma antena isotrópica ideal precisaria emitir para produzir a mesma densidade de potência na direção principal?”.
- EIRP não é potência total real irradiada se a antena tem ganho. Uma Yagi concentra energia em algumas direções; por isso pode ter EIRP maior que a potência total entregue à antena. Isso não viola conservação de energia, porque há menos energia nas outras direções.
- `dBW` é potência em dB relativa a 1 W: `P[dBW] = 10 log10(P[W])`. Assim, `10 W = 10 dBW`, `1 W = 0 dBW`, `100 W = 20 dBW`. `dBm` é relativo a 1 mW, então `0 dBW = 30 dBm`.
- No exemplo, `10 W` viram `10 dBW`; perdas de linha e acessórios tiram `3,6 dB`; a Yagi adiciona `18,5 dBi`. O resultado `24,9 dBW` equivale a cerca de `310 W` isotrópicos na direção de máximo.
- A perda de VSWR no slide deve ser entendida como perda adicional efetiva na cadeia: potência refletida, aumento de perda no cabo e desadaptação. Se o transmissor reduz potência por proteção, isso também reduz EIRP real.
- Perda de apontamento é muito importante em satélites. Uma antena direcional só dá ganho máximo no eixo; alguns graus de erro podem custar vários dB, especialmente em antenas de feixe estreito.
- Perda de polarização depende da geometria. Linear contra circular ideal perde `3 dB` porque uma antena linear capta apenas metade da potência de uma onda circular. Linear horizontal contra linear vertical ideal perde tudo no modelo, embora na prática multipercurso e imperfeições deixem algum sinal.
- Atmosfera e ionosfera são pequenas em VHF/UHF em muitos enlaces, mas não são sempre zero. Em SHF e acima, chuva, gases e nuvens podem dominar, especialmente em enlaces de baixa margem.
- Em contexto regulatório, EIRP/PIRE também importa porque limites de potência muitas vezes são expressos em potência radiada, não apenas potência no conector. Aumentar ganho de antena pode exigir reduzir potência do transmissor para permanecer dentro do limite.

## Slide 48 — Ruído do sistema: temperatura equivalente e G/T

- Receptor não é limitado apenas por potência recebida; é limitado por potência recebida em relação ao ruído. O ruído térmico disponível em uma banda `B` é `k T B`, onde `k` é a constante de Boltzmann, `T` é temperatura equivalente em kelvin e `B` é largura de banda em Hz.
- O termo `-228,6 dBW/K/Hz` vem de `10 log10(k)`, com `k` em W/K/Hz. Por isso `P_n[dBW] = -228,6 + 10 log10(T) + 10 log10(B)`.
- Temperatura equivalente não significa que o receptor está fisicamente a essa temperatura. É uma forma de expressar ruído como se viesse de uma resistência térmica equivalente.
- `T_a` é temperatura de antena: ruído captado do céu, Sol, galáxia, solo, cidade e objetos no lóbulo da antena. Uma antena apontada para céu frio pode ter ruído menor; apontada para solo quente, cidade ou Sol, maior.
- Perda antes do LNA é crítica porque uma perda passiva antes do primeiro amplificador reduz sinal e acrescenta ruído térmico. Um cabo com `1 dB` de perda antes do LNA pode piorar muito mais que `1 dB` na sensibilidade total.
- A fórmula com `a = 10^(-L/10)` representa isso: a perda transmite apenas fração `a` do ruído/sinal da antena e adiciona ruído próprio equivalente a `(1-a)T0`, assumindo componente passivo perto de `T0 = 290 K`.
- O ruído das etapas depois do LNA é dividido pelo ganho do LNA, como na fórmula de Friis de ruído. Por isso um LNA de baixo ruído e ganho suficiente, colocado perto da antena, torna menos importantes as perdas/ruídos das etapas seguintes.
- Figura de ruído `NF` em dB vira fator `F = 10^(NF/10)`. A temperatura equivalente do amplificador é `T_e = T0(F - 1)`. `NF = 3 dB` significa `F approx 2`, então `T_e approx 290 K`.
- Em `G/T`, `G` é o ganho linear da antena receptora, incluindo perdas antes do ponto de referência escolhido. Não é uma divisão de “dBi por kelvin”. Em unidades lineares, a figura é literalmente `G_linear / T_s`, com unidade `1/K`.
- Quando escrevemos em dB, fazemos `G/T [dB/K] = G [dBi] - 10 log10(T_s/K)`. Se houver perda antes do LNA ou antes do plano de referência, ela entra subtraindo do ganho: `G/T = G_a - L_pre-LNA - 10 log10(T_s)`. O rótulo `dB/K` significa “dB relativo a 1 por kelvin”, não que `dBi` foi dividido por kelvin.
- Exemplo: antena com `G_a = 10 dBi`, perdas pré-LNA de `1 dB` e `T_s = 300 K`. Como `10 log10(300) = 24,8 dB`, então `G/T = 10 - 1 - 24,8 = -15,8 dB/K`. Aumentar ganho ajuda; reduzir temperatura de ruído também ajuda. Para satélites, `G/T` resume a qualidade da estação receptora.
- O lugar onde `G/T` é usado é no cálculo de `C/N0`, a razão portadora-ruído por hertz. A forma em dB é `C/N0 = EIRP + G/T - L_path - L_outros + 228,6`. Ou seja: `EIRP` descreve o transmissor, `L_path` e perdas descrevem o caminho, e `G/T` resume a qualidade do receptor.
- Depois disso, convertemos `C/N0` em `Eb/N0` subtraindo a taxa de bits: `Eb/N0 = C/N0 - 10 log10(R_b)`. Portanto, `G/T` não é um número isolado; ele entra diretamente na conta que diz se a modulação vai decodificar.
- Largura de banda importa diretamente. Dobrar `B` aumenta ruído em `3 dB`. Modos estreitos conseguem operar com sinais mais fracos em potência total porque coletam menos ruído.

## Slide 49 — `Eb/N0` típico por modulação e FEC

- `Eb/N0` é energia por bit dividida pela densidade espectral de ruído. Ele mede qualidade por bit, não potência total. Por isso permite comparar sistemas com taxas de bits diferentes.
- `C/N0` é razão portadora-ruído por hertz, em `dB-Hz`. Ele diz quão forte está a portadora em relação à densidade de ruído. Para obter `Eb/N0`, subtraímos a taxa de bits: `Eb/N0 = C/N0 - 10 log10(R_b)`.
- `R_b` é a taxa de bits em bit/s usada para espalhar a potência recebida entre bits. Em uma conta simples, é a taxa de bits transmitida no canal. Se há FEC, é preciso verificar a convenção da tabela: alguns limiares usam `Eb/N0` por bit de informação útil; outros usam bit codificado no canal. Misturar taxa útil e taxa codificada desloca a conta pelo fator da taxa de código.
- A cadeia completa fica: calcular `EIRP`; somar `G/T` do receptor; subtrair perdas de caminho e outras perdas; somar `228,6` para converter `kT` em dB; obter `C/N0`; subtrair `10 log10(R_b)`; obter `Eb/N0`. Esse é o `Eb/N0 obtido` usado no slide de margem.
- A intuição é: se a potência recebida é fixa e aumentamos a taxa de bits, cada bit recebe menos energia. Dobrar `R_b` reduz `Eb/N0` em `3 dB`.
- `BER` é bit error rate, taxa de erro de bit antes ou depois de decodificação, dependendo da tabela. Sempre confira a definição: alguns valores são BER bruto, outros são BER após FEC.
- Modulações não coerentes ou implementadas sobre FM, como AFSK Bell 202, exigem `Eb/N0` alto porque a cadeia não é ótima em termos de detecção digital. Ela é simples e compatível com rádios FM de voz, mas paga em sensibilidade.
- BPSK/QPSK coerente sem FEC fica perto de `9--10 dB` para BER típico de `10^-5`, muito melhor que AFSK/FM. A diferença não é “mágica”; vem de usar melhor fase, largura de banda e detector coerente.
- FEC reduz o `Eb/N0` limiar porque acrescenta redundância que permite corrigir erros. O custo é reduzir taxa útil, aumentar complexidade e latência; entrelaçamento é uma técnica separada, usada apenas quando o padrão de erro do canal justificar.
- Código convolucional com Viterbi corrige melhor erros aproximadamente independentes; por isso entrelaçamento é muito comum com códigos convolucionais, pois transforma rajadas do canal em erros mais espalhados antes do decodificador. Reed-Solomon (`RS`) já corrige símbolos/bytes e, por isso, é naturalmente útil contra rajadas de bits concentradas em poucos símbolos: se 8 bits consecutivos estragam um único byte, isso conta como 1 erro de símbolo. Para RS, interleaving não é uma melhoria genérica: interleaving de bits pode piorar, espalhando uma rajada curta por muitos bytes. O caso útil é interleaving por símbolos/blocos entre várias codewords quando uma rajada longa excederia a capacidade de um único bloco RS.
- Os valores da tabela são referências de engenharia, não garantias universais. Implementação real, sincronismo, desvio de frequência, não linearidade, fading, Doppler, filtro, clock, quantização e interferência podem deslocar o limiar em vários dB.
- A constante `228,6` na fórmula de `C/N0` aparece porque `N0 = kT`, e em dB usamos `-10 log10(k) = 228,6` quando as unidades são SI. Ela entra somando quando usamos `G/T`.

## Slide 50 — Margem de enlace: verde, amarelo, vermelho

- Margem é a folga entre o que o enlace entrega e o que a modulação/codificação exige. Se `M = 0 dB`, o cálculo ideal está exatamente no limiar. Na prática isso é frágil: qualquer erro de apontamento, polarização, fading ou imprecisão derruba o enlace.
- No slide, a margem é margem em `Eb/N0`: `M = (Eb/N0)_obtido - (Eb/N0)_limiar`. O `Eb/N0 obtido` vem do link budget usando `EIRP`, `G/T`, perdas e taxa de bits. O `Eb/N0 limiar` vem da tabela de modulação/FEC para uma BER alvo.
- Exemplo conceitual: se o orçamento dá `Eb/N0 = 30 dB` e a modulação escolhida precisa de `23 dB`, a margem é `7 dB`. Se trocamos para uma codificação que precisa de `17 dB`, a margem sobe para `13 dB`, mantendo o mesmo RF.
- `M < 0 dB` significa que, pelas hipóteses do orçamento, o enlace não fecha. Pode até haver decodificação ocasional por sorte, menor taxa real ou condições melhores que o previsto, mas não é projeto confiável.
- `0--6 dB` é região marginal. Pode funcionar em passagens altas, com apontamento bom e pouco ruído, mas falhar em elevação baixa ou com operador inexperiente.
- `>= 6 dB` é margem mínima prática em muitos projetos porque absorve erros de modelo: perdas de cabo subestimadas, ganho real menor, polarização imperfeita, ruído local, variação de atitude do satélite e tolerâncias.
- Margem de `10 dB` em projeto educacional ou baixo custo é confortável porque equipamento, antena, apontamento e ambiente costumam ser menos controlados que em missão profissional.
- Cada `3 dB` de margem equivale a fator 2 em potência. Se há `3 dB` sobrando, poderíamos reduzir potência de transmissão pela metade, ou tolerar perda adicional de `3 dB` em outro ponto.
- Em espaço livre, alcance escala com raiz quadrada da potência: `6 dB` a mais permite aproximadamente dobrar distância; `3 dB` permite multiplicar distância por `sqrt(2)`, se todo o resto for igual.
- FEC melhora margem reduzindo o `Eb/N0` limiar, mas não cria informação do nada. Se o canal tiver apagamentos longos, sincronismo ruim ou pacotes perdidos por colisão, FEC pode não recuperar. Para RS, o ganho depende do padrão de erros: rajadas concentradas em poucos símbolos são favoráveis; erros espalhados por símbolos demais ou colisões podem exceder a capacidade do bloco.
- Margem deve ser calculada para o pior caso relevante, não apenas para a melhor passagem. Em satélite LEO, distância, elevação, perdas de apontamento e Doppler mudam durante a passagem.

## Slide 51 — Efeito Doppler em órbitas LEO

- Doppler aparece porque há velocidade radial entre satélite e estação. Só a componente da velocidade na linha de visada importa: `Delta f = f v_r/c`. Velocidade tangencial pura não desloca a frequência de primeira ordem.
- Em LEO, o satélite se move rápido, mas `v_r` não é constante. No início da passagem, ele se aproxima e a frequência recebida fica mais alta. Perto do ponto de maior elevação, a velocidade radial pode cruzar zero. No fim, ele se afasta e a frequência fica mais baixa.
- O deslocamento é proporcional à frequência. Por isso o mesmo satélite causa cerca de três vezes mais Doppler em `437 MHz` do que em `145 MHz`.
- Em FM larga para APRS na ISS, `±3,6 kHz` em `145,825 MHz` normalmente cabe dentro da largura útil do canal e do receptor. AFSK 1200 bps tolera isso razoavelmente, então muitos operadores não corrigem Doppler em VHF FM.
- Em UHF, `±10 kHz` já é grande. Para SSB, CW e modos digitais estreitos, isso desloca o sinal por várias larguras de canal. É necessário corrigir continuamente ou em passos durante a passagem.
- O Doppler muda rápido perto do TCA em passagens altas. Em passagens baixas, o pico de Doppler pode durar mais tempo, mas o sinal costuma ser mais fraco por maior distância e menor elevação.
- Em enlace via repetidor linear, uplink e downlink têm Doppler em frequências diferentes. O operador pode precisar ajustar uma das pontas ou usar software CAT para controlar rádio automaticamente.
- Doppler não é erro de oscilador. Mesmo com osciladores perfeitos, o deslocamento ocorre por geometria orbital. Erro de oscilador e deriva térmica somam por cima, especialmente em SHF e receptores simples.

## Slide 52 — QO-100: GEO muda a geometria do enlace

- QO-100 é um transponder de radioamador em satélite geoestacionário. Geoestacionário significa que, visto da Terra, o satélite fica quase parado no céu porque orbita no plano equatorial com o mesmo período de rotação da Terra.
- A diferença operacional para LEO é enorme. Na ISS, há passagens curtas, Doppler forte e antena precisa acompanhar o satélite. No QO-100, a antena fica fixa, o satélite está disponível continuamente e o Doppler geométrico é pequeno.
- A desvantagem é a distância. Um GEO está a dezenas de milhares de quilômetros, enquanto a ISS pode estar a algumas centenas ou poucos milhares de quilômetros. A FSPL de GEO é muito maior, exigindo antenas de alto ganho e frequências SHF.
- No Brasil, o problema não é só distância; é elevação. Como o QO-100 está em `25,9 E`, ele fica muito baixo no horizonte para grande parte do país, especialmente Sul, Centro-Oeste oeste e Norte oeste. Baixa elevação aumenta obstruções, ruído de solo, perdas atmosféricas e dificuldade mecânica.
- “Footprint” é a região da Terra iluminada pelo feixe do satélite com potência suficiente. Estar no footprint não garante enlace confortável: dentro dele ainda variam elevação, margem, tamanho de antena, perdas e ruído.
- Em SHF, visada limpa é crítica. Árvores, prédios, morros, telhados e chuva podem degradar muito mais que em VHF. Uma elevação de `5--7 graus` exige horizonte extremamente livre.
- LNB de TV via satélite é barato e sensível, mas seu oscilador local pode derivar com temperatura. No QO-100, muitas vezes a deriva do LNB domina mais que Doppler; por isso alguns operadores usam LNB com referência externa ou correção por beacon.
- A tabela de elevação deve ser lida como orientação, não garantia. Pequenas diferenças de localização, altura da antena e horizonte local podem decidir se o enlace funciona. Um WebSDR ativo em região marginal prova viabilidade com instalação cuidadosa, não que qualquer varanda funcione.

## Slide 53 — Planilha AMSAT-IARU: workflow

- A planilha AMSAT-IARU organiza o link budget para reduzir esquecimento de termos. O valor dela está menos em “fazer contas difíceis” e mais em forçar o projetista a declarar hipóteses: órbita, frequência, antenas, perdas, ruído, modulação e margem.
- A aba de órbita define geometria: LEO, GEO, distância, elevação mínima e, portanto, perdas de caminho e janelas. Para LEO, o pior caso pode ser baixa elevação; para GEO, o caso é praticamente fixo, mas depende muito da elevação local.
- A aba de frequência determina `lambda` e FSPL. Mudar de VHF para UHF ou SHF altera perda de espaço livre, ganho possível das antenas, Doppler e perdas atmosféricas.
- Transmitter e Receiver devem ser preenchidos como cadeias físicas. No TX, potência do rádio não é potência radiada; há cabos, filtros, conectores, acopladores e antena. No RX, perdas antes do LNA são muito mais críticas que perdas depois do LNA.
- A aba de ganho de antena ajuda, mas não substitui dados reais. Ganho de Yagi, hélice ou parábola depende de eficiência, construção, apontamento e polarização. Se o ganho usado for otimista, a margem calculada fica falsa.
- Perdas de apontamento são importantes porque antenas de alto ganho têm feixe estreito. Uma parábola pequena em SHF já pode perder vários dB se apontada alguns graus fora.
- Perda de polarização precisa combinar polarização da estação e do satélite. Linear vs circular, circular direita vs esquerda, razão axial imperfeita e rotação de Faraday podem entrar aqui dependendo da frequência e sistema.
- A aba de modulação/FEC transforma escolha de protocolo em limiar de `Eb/N0`. É aqui que uma escolha física vira escolha digital: AFSK simples exige mais margem que BPSK com FEC, mas é muito mais fácil de implementar com rádio FM comum.
- A classificação verde/amarelo/vermelho deve ser usada como triagem, não como verdade absoluta. Se a planilha diz verde com `6 dB`, ainda precisamos validar hipóteses; se diz amarelo, talvez funcione em melhores passagens; se diz vermelho, procure qual termo domina a perda.
- Não edite células de fórmula como se fossem entradas. O risco em planilhas complexas é quebrar a lógica sem perceber. Use as cores e mantenha uma cópia limpa.

## Slide 54 — Exemplo: APRS via ISS em 145,825 MHz

- APRS via ISS é didaticamente excelente porque combina antena real, passagem orbital, protocolo de pacote, operação em VHF e feedback observável: o pacote pode aparecer em igates ou sites de rastreamento APRS.
- A ISS usa APRS em `145,825 MHz` quando o equipamento está ativo nessa configuração. É essencial verificar o status ARISS, porque a estação pode estar em manutenção, outro modo, desligada ou com indicativo/alias diferente.
- `AOS` é acquisition of signal, início da recepção; `LOS` é loss of signal, fim da passagem; `TCA` é time of closest approach, geralmente perto da maior elevação. A janela curta exige preparar tudo antes da passagem.
- `Whip` significa antena chicote: um elemento simples, aproximadamente monopolo, usado em rádios portáteis, veículos e também em algumas instalações espaciais. No orçamento do slide, `whip ISS` é a antena simples da estação a bordo, com ganho modesto e padrão relativamente amplo, não uma Yagi apontada para a Terra.
- No slide 54, a tabela mostra primeiro a potência de sinal que chega ao receptor da ISS: `EIRP - perdas + G_r = P_sinal`. O `G/T` não aparece como coluna separada porque o ganho da antena receptora (`+ G_r` da whip ISS) foi colocado explicitamente na conta de potência. Para transformar esse `P_sinal` em `Eb/N0`, ainda é preciso dividir pelo ruído do receptor da ISS, isto é, usar a temperatura de sistema assumida para obter `C/N0` e depois subtrair `10 log10(R_b)`.
- A forma equivalente seria agrupar o receptor da ISS como `G/T`: `C/N0 = EIRP - L_path - L_outros + (G/T)_ISS + 228,6`. A tabela do slide abre o `G` separadamente e deixa o `T` implícito na etapa que produz o `Eb/N0 ideal`.
- O orçamento ideal no zênite é muito favorável para `5 W` e Yagi, mas a prática é mais difícil. O canal é compartilhado, há colisões, captura FM, polarização variável, atitude da ISS, obstáculos, erro de apontamento, áudio mal ajustado, squelch e timing de transmissão.
- Em FM, captura significa que o receptor tende a demodular o sinal mais forte e suprimir sinais simultâneos mais fracos. Se muitos usuários transmitem ao mesmo tempo, pacotes colidem; potência maior nem sempre resolve de forma cooperativa.
- A polarização da ISS pode variar porque a orientação relativa entre antenas muda durante a passagem. Uma Yagi linear na mão pode sofrer fading por rotação de polarização; girar a antena às vezes melhora o sinal.
- AFSK Bell 202 usa áudio: tons de `1200/2200 Hz` modulam o rádio FM. Volume de áudio, desvio, filtros do celular, VOX, squelch e cabos influenciam muito. Um link budget de RF bom não corrige áudio saturado ou baixo demais.
- O squelch deve ser tratado com cuidado. Squelch fechado pode cortar o início do pacote recebido; em transmissão, VOX pode atrasar o começo do áudio. Para decodificação, muitas vezes é melhor squelch aberto e volume estável.
- Doppler em VHF FM geralmente é tolerável, mas a frequência do rádio ainda deve estar correta. Em HTs baratos, erro de referência e passo de sintonia podem somar alguns kHz.
- O melhor procedimento prático é primeiro escutar e decodificar pacotes da ISS; depois tentar transmitir. Receber confirma antena, frequência, passagem e áudio antes de disputar o canal de uplink.

## Slide 55 — QO-100: orçamento em SHF e cadeia de RF

- QO-100 usa uplink em `2,4 GHz` e downlink em `10,5 GHz`. Essas frequências permitem antenas pequenas com alto ganho, mas tornam cabos, conectores, apontamento, estabilidade de frequência e perdas muito mais críticos que em VHF.
- `NB` significa narrowband: transponder de banda estreita para SSB, CW e modos digitais estreitos. `DATV` fica no transponder wideband e exige outra cadeia de vídeo, largura de banda e potência.
- No uplink de `2,4 GHz`, a antena precisa gerar polarização circular direita (`RHCP`) para casar com o transponder. Hélice axial é popular porque produz circularidade razoável com construção simples; uma parábola com feed adequado aumenta o ganho.
- Transverter converte um sinal de rádio HF/VHF/IF para `2,4 GHz`. Isso permite usar rádio SSB comum como fonte de áudio/modulação e deslocar a frequência para SHF com osciladores e misturadores.
- No downlink de `10 GHz`, LNB de TV é usado porque combina antena de baixo ruído, amplificador e conversor de frequência. Ele recebe em banda X/Ku próxima, mistura com um oscilador local e entrega uma frequência intermediária (`IF`) em torno de centenas de MHz, que um SDR barato consegue receber.
- O LNB precisa ficar no foco da parábola porque perda antes do primeiro amplificador degrada diretamente o `G/T`. Diferente de VHF, alguns centímetros ou conectores ruins em SHF podem ter impacto grande se estiverem antes do LNA.
- O orçamento mostra FSPL enorme, cerca de `205 dB`, mas a parábola recupera muito ganho: uma antena de `60 cm` em `10 GHz` pode ter da ordem de `35 dBi`. Em frequência alta, uma abertura física modesta vira muitos comprimentos de onda.
- No slide 55 acontece a mesma separação: a tabela calcula `P_sinal` no receptor usando `EIRP do satélite - perdas + G_r da parábola`. O `G/T` entra quando avaliamos a qualidade desse sinal contra o ruído do sistema. Como o LNB está no foco, a perda pré-LNA é quase zero e a temperatura de sistema fica baixa; por isso o `G/T` da estação melhora bastante.
- Se reescrevermos o downlink diretamente em forma de `C/N0`, o termo `+ G_r` da tabela e a temperatura de ruído do LNB/receptor viram um único termo `G/T`: `C/N0 = EIRP_sat - FSPL - L_outros + (G/T)_estacao + 228,6`.
- Baixa elevação no Brasil torna a instalação sensível. Em `7 graus`, qualquer obstáculo baixo no horizonte bloqueia. O lóbulo da parábola também pode enxergar mais solo/ruído e atravessar mais atmosfera.
- Para SSB, a métrica prática muitas vezes é `SNR` em largura de áudio, como `2,4 kHz`, não `Eb/N0`. Para modos digitais estreitos, volta-se a usar energia por bit ou métricas equivalentes.
- Em QO-100, estabilidade de frequência é tão importante quanto potência. Deriva do LNB, SDR, transverter ou oscilador pode fazer o sinal passear no waterfall. Referência externa por GPSDO ou beacon ajuda.

## Slide 56 — ISS vs. QO-100: comparativo operacional

- A tabela mostra dois extremos do mesmo arcabouço. ISS é perto, móvel e temporária; QO-100 é longe, fixo e contínuo. Friis, `G/T`, polarização, perdas e margem continuam sendo as mesmas ferramentas.
- Na ISS, a baixa distância reduz FSPL e permite operar com HT e Yagi simples. O custo operacional é rastrear passagem curta, lidar com Doppler, polarização variável e congestionamento do canal.
- No QO-100, a distância enorme aumenta FSPL, mas a geometria fixa permite usar parábola apontada permanentemente e operar por horas. O custo técnico migra para SHF, LNB, SDR, transverter, estabilidade e visada limpa.
- A comparação de potência recebida pode parecer surpreendente: apesar da FSPL do QO-100 ser muito maior, o ganho da parábola em `10 GHz` também é muito maior. Por isso o sinal final pode ficar na mesma ordem de grandeza da ISS.
- Antena de abertura fixa ganha com frequência: para uma parábola de mesmo diâmetro, ganho cresce aproximadamente com `1/lambda^2`, ou seja, com `f^2`. Isso compensa parte da FSPL, que também cresce com `f^2` para antenas de ganho fixo. A interpretação depende de manter ganho fixo ou área física fixa.
- O Doppler em GEO é desprezível por geometria, mas não significa “frequência perfeita”. Em SHF, deriva térmica de osciladores é muito perceptível. No LEO, a dominante é movimento orbital.
- A ISS cobre todo o Brasil em passagens diferentes porque está baixa e passa por várias órbitas. QO-100 tem footprint fixo e, no Brasil, favorece leste/nordeste. Localização geográfica decide viabilidade.
- Como exercício, é interessante calcular ambos com os mesmos blocos: EIRP, FSPL, ganho RX, perdas, ruído e margem. Isso mostra que link budget não é uma fórmula de satélite específico; é uma linguagem geral.

## Slide 57 — AX.25: HDLC levado para o rádio

- `AX.25` é adaptação radioamadora de ideias do HDLC/LAPB para comunicação em pacote. Ele define enquadramento, endereços, controle, CRC e alguns modos de operação.
- A flag `0x7E` delimita começo e fim porque o receptor precisa saber onde o quadro começa em um fluxo contínuo de bits. Em binário, `0x7E = 01111110`.
- Bit stuffing evita que o padrão da flag apareça acidentalmente dentro dos dados. Depois de cinco bits `1` consecutivos no payload codificado, o transmissor insere um `0`; o receptor remove esse `0`. Assim, `01111110` fica reservado como delimitador.
- FCS é frame check sequence, um CRC-16. Ele detecta erro com alta probabilidade, mas não corrige. Se o FCS não bate, o quadro é descartado silenciosamente.
- AX.25 usa indicativos como endereços porque no Serviço de Radioamador a identificação da estação é parte do protocolo operacional. O `SSID` permite diferenciar múltiplas interfaces/serviços do mesmo indicativo, como `-7`, `-9`, `-10` etc.
- Digipeaters são repetidores de pacote em nível de quadro. O caminho de digipeaters no cabeçalho diz quais estações podem retransmitir ou já retransmitiram o pacote.
- APRS usa quadro `UI` porque é broadcast leve: posição, telemetria e mensagens curtas são enviadas para quem estiver ouvindo, sem estabelecer conexão AX.25. Isso é eficiente para canal compartilhado e móvel.
- Sem ACK na camada AX.25, confiabilidade depende da aplicação e da repetição. Mensagens APRS podem ter ACK próprio na aplicação, mas beacons de posição normalmente são “envia e esquece”.
- Em canal de rádio, quadro longo é mais vulnerável: um único bit errado faz o FCS falhar e o quadro inteiro desaparecer. Por isso tamanho de pacote, taxa e ocupação do canal importam.

## Slide 58 — AX.25: formato do frame UI

- O quadro UI é o formato básico usado pelo APRS. Ele carrega endereços AX.25, controle `UI`, PID e o payload APRS no campo `Info`.
- Cada endereço AX.25 ocupa 7 bytes: seis caracteres de indicativo, preenchidos com espaços se necessário, mais um byte com SSID e bits de controle. Em transmissões reais, os caracteres do indicativo são deslocados um bit à esquerda no formato AX.25.
- O destino em APRS muitas vezes não é uma pessoa. Pode ser `APRS`, `APNxxx`, `CQ` ou identificador de software/dispositivo. A semântica útil para roteamento no ar está mais no caminho de digipeaters e no payload.
- O campo de digipeaters pode ter até 8 endereços, mas usar muitos saltos ocupa canal e aumenta colisões. APRS moderno recomenda caminhos curtos e compatíveis com a rede local, como `WIDE1-1,WIDE2-1` em alguns contextos terrestres.
- Em satélite, o caminho muda. Para ISS, costuma-se usar alias como `ARISS` ou `APRSAT`, conforme status operacional. Usar caminho terrestre WIDE em satélite pode ser inútil ou inadequado.
- `Control = 0x03` identifica UI: quadro não numerado e sem conexão. `PID = 0xF0` indica que não há protocolo de camada 3; o conteúdo APRS vai direto no campo Info.
- O FCS vem antes da flag final e é calculado após bit stuffing ser considerado no fluxo HDLC. O receptor valida o FCS depois de recuperar os bits. Se falhar, o pacote normalmente nem aparece para a aplicação.
- O limite de `Info` até 256 bytes é generoso para APRS, mas canal compartilhado favorece pacotes curtos. Beacon longo demais aumenta tempo no ar e probabilidade de colisão.
- Em 1200 bps, um pacote de algumas centenas de bytes pode ocupar uma fração perceptível de segundo no canal. Como APRS usa ALOHA/canal compartilhado, disciplina de taxa de beacon é parte da engenharia.

## Slide 59 — AX.25 conectado: mais que só APRS

- APRS usa AX.25 UI porque quer difusão local. Mas AX.25 completo também suporta modo conectado, parecido com uma sessão de enlace confiável entre duas estações.
- I-frames carregam dados numerados. `N(S)` identifica o número do quadro enviado; `N(R)` confirma até qual quadro foi recebido. Isso permite retransmissão ordenada e controle de fluxo.
- S-frames supervisionam a sessão. `RR` diz “pronto para receber”; `RNR` diz “não pronto”; `REJ` solicita retransmissão a partir de um ponto. Eles não carregam dados de usuário, mas mantêm o enlace.
- U-frames controlam a conexão. `SABM` inicia modo balanceado assíncrono; `UA` confirma; `DISC` desconecta; `UI` é o quadro não conectado usado pelo APRS.
- BBS de pacote eram serviços de mensagens em rádio antes da internet popular. O operador conectava via AX.25 a um nó ou BBS, lia mensagens, deixava recados e podia encaminhar tráfego por redes store-and-forward.
- Store-and-forward significa que uma estação intermediária armazena a mensagem e retransmite depois, quando houver caminho. Isso é diferente de um repetidor de voz em tempo real.
- NET/ROM, TheNET e JNOS adicionavam roteamento e serviços por cima de AX.25, permitindo redes de nós. Winlink é herdeiro moderno no sentido de transportar mensagens por rádio com integração a e-mail, embora use também outros protocolos e modos.
- O modo conectado é mais eficiente para transferência confiável entre dois pontos quando o canal está limpo, mas pode ser ruim em canal compartilhado congestionado, porque retransmissões e ACKs ocupam tempo no ar.
- APRS preferiu broadcast UI porque posição e telemetria são informações efêmeras: se um beacon se perde, o próximo atualiza. Não vale a pena abrir conexão para cada posição.

## Slide 60 — APRS: tipos de pacote

- O Data Type Identifier é o primeiro caractere do campo `Info`. Ele diz ao software APRS como interpretar o restante do payload.
- `!` e `=` indicam posição sem timestamp; a diferença é se a estação aceita mensagens APRS. A posição inclui latitude, longitude, símbolo e comentário.
- `/` e `@` incluem timestamp. Isso é útil quando o pacote pode atrasar, ser retransmitido ou chegar por internet depois; o receptor sabe quando aquela posição foi válida.
- `:` indica mensagem. O destino tem campo fixo de 9 caracteres, seguido do texto. Quando há identificador entre chaves, o receptor pode enviar ACK de aplicação. Isso é separado de ACK AX.25.
- `>` é status: texto livre como descrição da estação, frequência de voz, software, evento ou informação operacional. Não deve ser usado para spam repetitivo em alta taxa.
- `_` é weather sem posição no próprio pacote. Estações meteorológicas podem transmitir vento, temperatura, chuva, pressão e outros campos em formatos APRS específicos.
- `;` cria objeto: uma entidade nomeada no mapa que pode representar repetidora, evento, balão, recurso de emergência, estação temporária etc. O objeto pode ser criado por uma estação diferente da entidade representada.
- `)` cria item, parecido com objeto, mas com semântica mais leve/persistente em alguns usos. Na prática, softwares APRS diferenciam objetos e itens no tratamento de mapa.
- `T` é telemetria: canais analógicos e digitais para sensores, bateria, temperatura, contadores ou estados. Pacotes adicionais podem definir nomes, unidades e equações de escala.
- Mic-E é uma codificação compacta e histórica que coloca parte da posição no campo destino AX.25. Economiza bytes, mas é menos legível manualmente.
- Pacotes user-defined (`{`) existem para experimentação, mas interoperabilidade depende dos receptores entenderem. Em rede APRS pública, formatos padronizados são preferíveis.

## Slide 61 — APRS: símbolos e digipeating

- Símbolo APRS é a combinação de tabela e glifo. A tabela primária e a alternada permitem reutilizar caracteres para ícones diferentes. Alguns símbolos ainda aceitam sobreposição com letra ou dígito para indicar subtipo.
- O SSID histórico ajuda quando não há posição/símbolo explícito, mas hoje o símbolo no payload é a forma preferida. Não escolha SSID apenas pelo ícone; escolha de SSID também comunica função operacional da estação.
- `-9` é usado frequentemente para móvel, `-7` para HT/portátil, `-11` para balão, mas isso é convenção comunitária, não mecanismo de roteamento. O caminho real de repetição fica no campo de digipeaters.
- `WIDEn-N` é uma forma de limitar saltos. `WIDE` é um alias genérico entendido por digipeaters APRS; `N` é o número de repetições ainda permitidas. Em `WIDE2-2`, o `2` depois do hífen diz que ainda podem ocorrer dois saltos; cada digipeater que repete decrementa esse contador: `WIDE2-2` vira `WIDE2-1`, depois `WIDE2*` ou equivalente quando esgota.
- O primeiro número em `WIDE2-2` não deve ser lido como “classe/capacidade” física do caminho. Na prática moderna, ele identifica o tipo de alias/recomendação de caminho. `WIDE1-1` costuma ser usado para permitir um primeiro salto por um fill-in digipeater local; `WIDE2-1` ou `WIDE2-2` pede saltos por digipeaters de maior cobertura. A recomendação exata depende da rede local.
- Supressão de duplicatas é essencial porque vários digipeaters podem ouvir o mesmo pacote. Sem filtro por duplicata, uma única transmissão poderia se multiplicar em tempestade de repetições.
- `IGate` é uma estação que escuta APRS RF e encaminha pacotes para a rede APRS-IS na internet. Alguns IGates também fazem caminho inverso, internet para RF, mas isso deve ser feito com muito cuidado para não congestionar o canal local.
- APRS-IS não é “o APRS”; é a rede de servidores na internet que agrega pacotes. O APRS original é protocolo e rede RF local. Sites de mapa geralmente mostram dados vindos de APRS-IS.
- Via ISS, um único pacote pode cobrir milhares de quilômetros porque o satélite enxerga grande área da superfície. Isso é poderoso, mas torna o canal muito disputado: beacon excessivo atrapalha usuários em escala continental.
- Para satélite, use aliases e caminhos recomendados pelo operador do satélite. Caminhos terrestres como `WIDE2-2` não fazem sentido através da ISS e podem causar comportamento indesejado se o pacote voltar para redes terrestres.

## Slide 62 — Modulações AX.25/APRS

- Bell 202 AFSK usa tons de áudio dentro de um rádio FM comum. A grande vantagem é compatibilidade: qualquer HT com entrada de microfone e saída de áudio pode participar, inclusive com celular gerando/decodificando áudio.
- AFSK não é FSK de RF direta. O rádio FM está modulando frequência com um sinal de áudio que alterna tons. Por isso filtros de áudio, compressão, pré-ênfase, de-ênfase, volume, VOX e desvio afetam a decodificação.
- `NRZI` significa Non-Return-to-Zero Inverted. Em AX.25, a transição ou ausência de transição representa bits antes da etapa AFSK. Isso ajuda com sincronismo e compatibilidade com HDLC.
- O preâmbulo com flags `0x7E` repetidas dá tempo para o receptor abrir squelch, estabilizar áudio, recuperar clock e reconhecer início de quadro. Se VOX ou squelch cortar o começo, o pacote pode falhar mesmo com sinal forte.
- G3RUH 9600 bps é FSK direta/baseband mais exigente. O caminho de áudio de muitos rádios de voz não é plano o suficiente; por isso se usa entrada de dados ou acesso à discriminadora/modulador, evitando filtros de voz.
- Scrambler LFSR espalha transições e evita sequências longas problemáticas para clock e espectro. Ele não é criptografia; é embaralhamento determinístico para propriedades de sinal.
- O problema de propagação de erro no descrambler é real: um bit errado pode afetar múltiplos bits depois de descrambler. Interleaving e FEC reduzem o impacto percebido pelo pacote.
- BPSK exige referência de fase ou recuperação coerente, e geralmente cadeia linear. Em troca, pode ter desempenho muito melhor em `Eb/N0`. SDR facilita porque preserva amostras I/Q e permite processamento digital sofisticado.
- GMSK tem envelope constante, bom para PAs não lineares, mas exige caminho de dados com resposta adequada. Se passar por filtros de voz estreitos ou áudio acoplado por capacitor de forma inadequada, o olho fecha e a BER piora.
- A escolha de modulação é compromisso: compatibilidade e simplicidade favorecem AFSK/FM; eficiência espectral e sensibilidade favorecem modulações coerentes/digitais modernas.

## Slide 63 — Reed-Solomon: intuição visual

- Reed-Solomon é um código corretor de erros por blocos. A intuição do slide é interpolação: se uma mensagem define um polinômio, avaliações redundantes desse polinômio permitem reconstruí-lo mesmo se algumas avaliações chegarem erradas.
- A ideia “k pontos determinam polinômio de grau k-1” é a base. A mensagem contém `k` símbolos de informação; o codificador gera `n` símbolos avaliando ou, em implementações sistemáticas, adicionando paridade equivalente.
- O código é útil contra erros em rajada porque opera em símbolos, normalmente bytes. Um byte completamente corrompido conta como um símbolo errado, independentemente de quantos bits dentro dele mudaram.
- A figura com pontos deslocados mostra redundância geométrica. Se poucos pontos estão errados, ainda há uma única curva de grau baixo que explica a maioria dos pontos. O decodificador encontra essa curva e recupera a mensagem.
- Na prática, decodificadores RS não testam todas as combinações de pontos. Usam algoritmos algébricos eficientes, como Berlekamp-Massey, Euclides estendido, Forney etc. A intuição geométrica ajuda a entender capacidade, não o algoritmo completo.
- Reed-Solomon não aumenta potência recebida nem corrige quadro totalmente ausente. Ele troca taxa útil por robustez: envia símbolos extras para corrigir alguns símbolos errados dentro do bloco recebido.
- Se o canal produz rajadas mais longas que a capacidade do bloco, pode-se usar interleaving por símbolos/blocos para distribuir a rajada por vários blocos RS. Isso pode melhorar a correção, mas aumenta latência e memória. Se a rajada já está concentrada em até `t` símbolos do mesmo bloco, entrelaçar não é necessário. Interleaving de bits antes de um RS byte-oriented pode ser prejudicial, porque transforma uma rajada compacta em erros distribuídos por mais bytes.

## Slide 64 — RS: correção de erros `t <= (n-k)/2`

- `n` é o número total de símbolos transmitidos no bloco; `k` é o número de símbolos de informação. A diferença `n-k` é redundância de paridade.
- A distância mínima de Reed-Solomon é `d_min = n-k+1`. Isso significa que duas palavras-código válidas diferem em pelo menos `n-k+1` símbolos.
- Para corrigir erros de posição desconhecida, cada erro “custa” duas unidades de redundância: precisamos descobrir onde está o erro e qual é seu valor. Por isso a capacidade é `t <= (n-k)/2`.
- Para apagamentos, a posição já é conhecida. Se o receptor sabe quais símbolos são duvidosos ou ausentes, só precisa descobrir os valores. Por isso apagamento custa uma unidade, e a regra geral vira `s + 2t <= n-k`.
- Exemplo RS(255,223): há `32` bytes de paridade. Ele corrige até `16` bytes errados de posição desconhecida, ou até `32` apagamentos, ou combinações como `10` apagamentos e `11` erros, porque `10 + 2*11 = 32`.
- A porcentagem de bytes corrigíveis não conta toda a história. RS corrige até `t` símbolos errados em qualquer posição do bloco; esses símbolos podem estar juntos ou separados. Uma rajada de bits que fica dentro de poucos bytes é um caso favorável para RS, justamente sem interleaver. Um interleaver só ajuda quando a rajada atravessa símbolos demais de um mesmo bloco e é distribuída entre codewords diferentes; não é a mesma motivação do interleaving usado com códigos convolucionais.
- Quando o número de erros passa da capacidade, o decodificador pode declarar falha ou, pior, corrigir para uma palavra errada se não houver verificação externa. Por isso protocolos costumam manter CRC além de FEC.
- Reed-Solomon corrige símbolos, não bits isolados. Em GF(2^8), um símbolo é um byte. Se um byte tem 1 bit errado ou 8 bits errados, ambos contam como um símbolo errado.

## Slide 65 — RS sobre GF(2^m): bytes como pontos

- Reed-Solomon precisa de operações algébricas em um conjunto finito onde soma, subtração, multiplicação e divisão funcionam sem sair do conjunto. Esse conjunto é um corpo finito, como `GF(2^8)`.
- Em `GF(2^8)`, cada elemento pode ser representado por um byte, mas as operações não são aritmética inteira comum. Soma é XOR; multiplicação é multiplicação de polinômios módulo um polinômio redutor irredutível.
- O polinômio redutor define a “tabela de multiplicação” do campo. Diferentes padrões podem usar polinômios diferentes; transmissor e receptor precisam concordar.
- O elemento `alpha` é escolhido como elemento primitivo ou gerador: suas potências percorrem os elementos não nulos do campo. Por isso um código RS sobre `GF(2^8)` tem comprimento máximo típico `255`, que é `2^8 - 1`.
- A visão por avaliações de polinômio é didática. Implementações reais frequentemente usam forma sistemática/cíclica: os `k` bytes de dados aparecem literalmente no codeword e os `n-k` bytes de paridade são anexados. A capacidade de correção é a mesma.
- “Sem erro de arredondamento” é importante: tudo é discreto e exato. Não há aproximação de ponto flutuante; se as tabelas e o polinômio estão corretos, transmissor e receptor fazem exatamente a mesma álgebra.
- A conexão com CRC é conceitual: ambos usam polinômios sobre campos binários. CRC detecta erro calculando resto; Reed-Solomon usa estrutura algébrica mais rica para localizar e corrigir símbolos.
- O custo é processamento e overhead. RS(255,239), por exemplo, adiciona 16 bytes de paridade a 239 bytes de dados; a taxa é `239/255 approx 0,937`. RS(255,223) adiciona 32 bytes; taxa `223/255 approx 0,875`.

## Slide 66 — Decodificação RS: síndromes e localizador

- Síndrome é um resumo algébrico do erro. Se a palavra recebida é uma palavra-código válida, todas as síndromes esperadas dão zero. Se alguma síndrome não zera, há erro detectado.
- As síndromes não dizem diretamente “o byte 17 está errado por valor 0x3A”. Elas misturam posições e magnitudes dos erros em somas no corpo finito.
- A expressão `S_j = sum e_l X_l^j` se parece com uma soma de exponenciais. As incógnitas são `X_l`, que codificam posições, e `e_l`, que são magnitudes dos erros. Resolver RS é separar essas duas informações.
- O polinômio localizador `Lambda(z)` tem raízes relacionadas às posições dos erros. Em vez de guardar uma lista de posições, ele guarda um polinômio cujas raízes revelam essas posições.
- Berlekamp-Massey encontra o menor polinômio localizador compatível com a sequência de síndromes. Ele é análogo a encontrar a menor relação de recorrência que explica a sequência observada.
- Chien search testa candidatos sistematicamente: avalia `Lambda(z)` nas potências do campo. Quando dá zero, encontrou uma raiz; a raiz aponta para uma posição corrompida.
- Essa etapa descobre onde estão os erros, mas ainda não sabe quanto corrigir em cada posição. Por isso o próximo slide precisa do avaliador de erro e da fórmula de Forney.
- Para aula, o ponto mais importante é a separação: síndromes detectam e resumem; localizador acha posições; avaliador/Forney acha valores; por fim corrige-se o bloco.

## Slide 67 — Decodificação RS: avaliador e Forney

- Depois de Chien search, sabemos as posições dos erros. Falta saber a magnitude de cada erro, isto é, qual valor deve ser somado/subtraído naquele símbolo para restaurar a palavra-código.
- O polinômio de síndromes `S(z)` empacota as síndromes em uma série formal. O avaliador `Omega(z)` combina `S(z)` com o localizador `Lambda(z)` e retém apenas termos até o grau de paridade.
- A fórmula de Forney calcula a magnitude do erro em cada posição usando `Omega`, `Lambda` e a derivada formal `Lambda'`. Ela evita resolver explicitamente um sistema linear para as magnitudes a cada bloco.
- Derivada formal em `GF(2^8)` não é limite/calculo diferencial. É a regra algébrica de derivar polinômios: derivada de `a z^m` vira `m a z^(m-1)`, com os coeficientes interpretados no campo. Em característica 2, termos com expoente par podem desaparecer.
- “Subtrair” em `GF(2^8)` é o mesmo que somar, porque a soma é XOR e cada elemento é seu próprio inverso aditivo. Assim, corrigir o símbolo é fazer XOR com a magnitude calculada do erro.
- Se o localizador encontrou mais raízes do que a capacidade permite, ou se alguma etapa gera inconsistência, o decodificador deve declarar falha. Corrigir mesmo assim pode produzir miscorrection: um pacote aparentemente válido mas errado.
- Por isso é comum manter CRC/FCS além da FEC. O Reed-Solomon tenta corrigir; o CRC ajuda a verificar se o resultado final faz sentido.
- A cadeia `síndromes -> Berlekamp-Massey -> Chien -> Forney -> correção` é o fluxo clássico. Para o aluno, não é necessário decorar os detalhes algébricos, mas é importante entender a função de cada etapa.

## Slide 68 — IL2P: alternativa moderna ao AX.25

- `IL2P` significa Improved Layer 2 Protocol. Ele tenta preservar o uso prático de packet radio/APRS, mas substitui partes frágeis do AX.25 tradicional em canais ruidosos.
- A motivação principal é que AX.25 sem FEC descarta o frame inteiro se um único bit passar errado pelo FCS. Em canal marginal, isso transforma pequenos erros em perda total de pacote.
- IL2P usa Reed-Solomon para corrigir erros dentro do frame. Com 16 bytes de paridade em RS(255,239), ele corrige até 8 bytes errados por bloco, desde que o erro esteja dentro da capacidade.
- A remoção de flag `0x7E` e bit stuffing simplifica a estrutura em ambiente com FEC. Em vez de depender de delimitadores HDLC frágeis a erros, IL2P usa sync word fixo e estrutura mais adequada à decodificação moderna.
- Payload sistemático significa que os dados originais aparecem intactos no bloco, seguidos de paridade. Isso facilita compatibilidade interna e depuração: a FEC acrescenta redundância sem transformar tudo em uma sequência opaca.
- A interface KISS é importante porque muitos softwares de packet/APRS já falam KISS com TNCs. Um TNC híbrido pode oferecer AX.25 tradicional ou IL2P sem exigir que todos os aplicativos sejam reescritos.
- IL2P não é compatível no ar com AX.25. Uma estação AX.25 tradicional não decodifica um frame IL2P como se fosse AX.25. A compatibilidade é na interface de software/TNC, não no formato RF.
- “ISS ainda não suporta IL2P” é importante operacionalmente: para APRS via ISS, use AX.25/APRS tradicional no modo aceito pela estação espacial. IL2P é relevante para redes/digipeaters modernos que explicitamente o suportam.
- FEC não resolve colisão de pacotes. Se dois usuários transmitem simultaneamente e o receptor captura ou mistura sinais de forma severa, Reed-Solomon pode não ter bloco utilizável para corrigir.

## Slide 69 — IL2P: ganho de codificação no orçamento

- Ganho de codificação é a redução de `Eb/N0` necessária para atingir a mesma taxa de erro final quando usamos FEC. Se um sistema precisa de `23 dB` sem FEC e `20 dB` com FEC, o ganho prático é `3 dB`.
- O ganho não vem de RF mais forte; vem de usar redundância para recuperar bits/símbolos que chegaram corrompidos. É uma troca: menor taxa útil e mais processamento por maior robustez.
- RS(255,239) adiciona 16 bytes de paridade a 239 bytes úteis. O overhead é `16/239 approx 6,7%` em relação aos dados, ou taxa de código `239/255 approx 93,7%`. É custo pequeno para corrigir até 8 bytes errados por bloco.
- O ganho real de `1--3 dB` depende do canal. Em erro aleatório moderado ou rajadas contidas em poucos símbolos, pode ser bom. Em rajadas longas que excedem a capacidade do bloco, colisões, fading profundo ou perda de sincronismo, o ganho pode ser menor; interleaving por blocos pode ajudar apenas no caso específico das rajadas longas, não em colisões ou perda de sincronismo.
- `3 dB` é uma unidade prática poderosa: metade da potência, o dobro da potência, ou fator `sqrt(2)` em alcance ideal de espaço livre. Em enlace marginal, isso pode ser a diferença entre pacote decodificado e silêncio.
- FEC também melhora experiência operacional porque reduz retransmissões. Em canal compartilhado, menos retransmissão significa menos ocupação e menos colisões, desde que o overhead não seja exagerado.
- Comparar FEC com antena/LNA/potência é útil porque todos compram margem com custos diferentes. Antena maior custa tamanho e apontamento; LNA custa hardware e alimentação; potência custa bateria e aquecimento; FEC custa overhead, latência e CPU.
- O limite é que FEC não substitui boas práticas RF. Se a antena está mal casada, o áudio está saturado, o Doppler está fora, o cabo está irradiando ou há colisão constante, FEC apenas melhora uma parte do problema.

## Slide 70 — Síntese do módulo

- A síntese deve ser lida como encadeamento, não como lista solta. O módulo começa em regulamentação e termina em FEC porque um enlace real depende de tudo: autorização para transmitir, antena que irradia, linha que entrega potência, receptor com ruído aceitável e protocolo que sobrevive a erros.
- Radioamadorismo aparece como laboratório legal de RF. Ele permite experimentar antenas, satélites e modos digitais, mas sempre dentro de faixas, classes, identificação, potência, homologação/certificação aplicável e responsabilidade operacional.
- Antena não é apenas “fio no rádio”. Ela é uma estrutura distribuída que transforma corrente em campo distante. A impedância `R_r + R_d + jX` resume na porta o que Maxwell faz no espaço: parte da potência vira onda, parte vira calor, parte fica indo e voltando no campo próximo.
- Antenas eletricamente curtas ensinam uma lição central: casamento não é eficiência. É possível fazer o rádio enxergar `50 Omega` e ainda irradiar pouco se `R_r` for pequeno e as perdas de bobina, solo ou condutor forem grandes.
- Simulação e medição são complementares. NEC/PyNEC e OpenEMS resolvem modelos de Maxwell; NanoVNA mede o protótipo físico. Diferenças entre ambos são pistas: cabo, choke, material, solo, curvatura, conector, mão e suporte podem estar fora do modelo.
- Yagi-Uda mostra interferência aplicada: parasitas indutivos/capacitivos e espaçamentos corretos produzem fase de corrente que reforça uma direção. O ganho não vem de criar energia, mas de redistribuir energia angularmente.
- NanoVNA fecha a parte prática: calibrar no plano certo, separar ressonância de casamento, reconhecer modo comum e usar `S11/S21` para medir antenas, cabos, chokes, traps e filtros.
- Link budget transforma RF em decisão quantitativa. Friis dá potência recebida; `G/T` e ruído dizem qualidade de recepção; `Eb/N0` conecta RF ao demodulador; margem diz se o enlace fecha.
- ISS e QO-100 são exemplos opostos. A ISS é próxima, rápida, VHF/UHF, com passagem curta e Doppler. QO-100 é distante, fixo, SHF, com antena parabólica e estabilidade de oscilador. As contas são as mesmas; as escalas mudam.
- APRS/AX.25 mostra que receber portadora não basta. Bits precisam ser enquadrados, endereçados, verificados e interpretados. Um pacote pode falhar por RF, por colisão, por áudio, por FCS, por caminho APRS errado ou por protocolo.
- Reed-Solomon e IL2P fecham o ciclo: quando o canal erra alguns símbolos, podemos gastar redundância para recuperar informação. FEC compra margem em software, mas não substitui antena, casamento, apontamento e disciplina de canal.
- Como revisão para prova/projeto, os alunos devem conseguir responder: posso transmitir legalmente? minha antena está ressonante? está casada? está eficiente? o cabo está transformando a medida? há modo comum? qual é minha EIRP? qual é meu `G/T`? qual margem sobra para o modo digital escolhido?
