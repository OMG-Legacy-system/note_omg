# Scaletta Presentazione: Stato dell'Arte nella Migrazione di Sistemi Legacy

## 1. INTRODUZIONE: La Sfida della Modernizzazione (3-4 min)

**Contenuto della slide:**
I sistemi legacy, nonostante siano stati sviluppati decenni fa, continuano a supportare settori critici come finanza, governo e banking. Si stima che esistano 200-220 miliardi di linee di codice COBOL ancora operative (IBM), con un costo di riscrittura stimato tra $100-110 miliardi (32-50 centesimi per linea). Questi sistemi presentano sfide cruciali: hardware e compilatori obsoleti, mancanza di documentazione, expertise in via di estinzione, e rischi elevati per sistemi mission-critical. La modernizzazione non è più opzionale ma necessaria per garantire competitività, sicurezza e manutenibilità.

In fase di ricerca ci siamo concentrati su approcci basati su AI e non basati su AI, per poi dividere in macrosezioni

---

## 2. APPROCCI ARCHITETTURALI ALLA MIGRAZIONE (5-6 min)

### 2.1 Strangler Fig Pattern
**Contenuto della slide:**
Il pattern Strangler Fig (Martin Fowler) rappresenta un approccio evolutivo alla migrazione, ispirato all'albero tropicale che cresce attorno al suo ospite fino a sostituirlo completamente. Invece di una riscrittura totale ad alto rischio, il sistema moderno viene costruito gradualmente attorno al legacy. Un gateway/reverse proxy agisce come "interruttore intelligente" che indirizza le richieste ai microservizi modernizzati quando pronti, altrimenti al sistema legacy. Questo approccio minimizza i rischi, permette rollback immediati, mantiene la continuità operativa e consente validazione incrementale. È particolarmente efficace per la transizione da architetture monolitiche a microservizi.

### 2.2 Approccio Agile-Assisted
**Contenuto della slide:**
L'approccio tool-assisted Agile utilizza framework di dynamic instrumentation (come PIN) per estrarre comportamenti runtime da sistemi legacy: function points, complessità ciclomatica, pattern di accesso ai dati, percorsi di esecuzione critici. Questi dati vengono trasformati automaticamente in user stories Agile con stime basate su metriche reali. La suite include: tool per analisi dinamica, generazione automatica di test data, identificazione di codice morto/funzionalità realmente utilizzate, framework di augmented real-execution che permette la coesistenza e validazione tra componenti legacy e migrati. Questo metodo integra l'intero SDLC e supporta strategie incrementali come Chicken Little Migration.

---

## 3. SCOMPOSIZIONE AUTOMATICA IN MICROSERVIZI (4-5 min)

### 3.1 Approcci basati su Analisi delle API
**Contenuto della slide:**
Tecniche come API Similarity Graph analizzano REST API monolitiche per identificare automaticamente candidati microservizi. Il processo combina: (1) Similarità semantica tra API usando TF-IDF posizionale su URI e descrizioni, (2) Analisi delle response messages considerando riferimenti comuni e metodi HTTP, (3) Costruzione di grafi pesati con algoritmi di Normalized Cut, (4) Clustering via K-means con ottimizzazione Calinski-Harabasz. Limitazioni: dipendenza da frequenza delle parole, difficoltà con terminologie ambigue.

### 3.2 Approcci basati su Ottimizzazione Multi-Obiettivo
**Contenuto della slide:**
MSExtractor formula la scomposizione come problema di ottimizzazione multi-obiettivo risolto con algoritmi evolutivi (IBEA). Combina analisi strutturale (grafo delle dipendenze tra classi) e semantica (TF-IDF su identificatori e commenti). Ottimizza simultaneamente: massima coesione interna, minimo accoppiamento tra servizi, granularità controllata (bilanciamento dimensioni/numero servizi). Distingue classi interne da interfacce per calcoli più precisi. MicroMiner integra machine learning per classificare classi (Application/Entity/Utility), clustering guidato da relazioni statiche, e aggregazione basata su similarità semantica e dipendenze strutturali. Raggiunge 68% precisione e 77% recall con componenti ad alta coesione.

---

## 4. TOOL DI SUPPORTO ALLA MIGRAZIONE
Adesso analizziamo due tool di supporto alla migrazione
Il primo, XMainframe, è un esempio di approccio basato su Deep Learning - utilizza un Large Language Model specializzato addestrato specificamente per comprendere COBOL.

Il secondo, MigrationExp, rappresenta l'approccio Machine Learning classico - usa algoritmi di learning-to-rank per imparare da migrazioni reali.

Entrambi forniscono supporto decisionale agli sviluppatori durante il processo di migrazione.


### 4.1 XMainframe
**[SLIDE 1 - Introduzione]**
XMainframe rappresenta il primo LLM open-source specificamente ottimizzato per la comprensione di sistemi mainframe e codebase COBOL. È stato sviluppato da FPT Software AI Center e pubblicato su arXiv ad agosto 2024.
Per contestualizzare il problema che questo modello affronta: IBM stima che esistano tra 200 e 220 miliardi di linee di codice COBOL ancora in produzione, prevalentemente in settori mission-critical come banking, insurance e government. Il costo di riscrittura manuale è stimato tra 32 e 50 centesimi per linea, configurando quello che viene definito un hundred-billion-dollar challenge MarkTechPost.
La scelta di DeepSeek-Coder 7B come base model è strategica: DeepSeek ha dimostrato performance state-of-the-art su code understanding tasks, con un'architettura decoder-only che utilizza Multi-Head Latent Attention per la compressione del KV-cache e RoPE per il positional encoding. Questo lo rende un candidato ideale per domain adaptation verso linguaggi a bassa risorsa come COBOL


**KV-cache**
Durante l'inferenza autoregressive (quando il modello genera token uno alla volta), c'è un problema di efficienza: per generare il token N, il modello deve ricalcolare l'attention rispetto a tutti i token precedenti (1, 2, ..., N-1).
Per evitare di ricalcolare K e V ad ogni step, si usa il KV-cache: si memorizzano i vettori K e V dei token già processati e si riutilizzano. Questo velocizza l'inferenza ma consuma molta memoria GPU

**Multi-Head Latent Attention**
MLA è un'innovazione introdotta da DeepSeek-V2. L'idea è comprimere i vettori K e V in uno spazio latente a dimensionalità ridotta prima di memorizzarli nel cache.
In pratica:
Invece di cacheare K e V nella loro dimensione originale (es. 128 dim per head × 32 heads = 4096 dim totali)
Si proiettano in uno spazio latente compresso (es. 512 dim)
Al momento dell'uso, si decomprimono on-the-fly

**RoPE**
 codifica le posizioni relative tra token attraverso rotazioni nello spazio complesso, permettendo una migliore generalizzazione su sequenze lunghe.
Rotary Position Embedding codifica la posizione ruotando i vettori Query e Key nello spazio complesso.
L'intuizione matematica:
Ogni posizione p corrisponde a una rotazione di angolo θ·p
Quando calcoli il dot product Q·K tra due token alle posizioni i e j, il risultato dipende solo dalla distanza relativa (i - j), non dalle posizioni assolute
Vantaggi:
Extrapolation: generalizza meglio a sequenze più lunghe di quelle viste in training
Relative positioning: cattura naturalmente le relazioni relative tra token
Efficienza: si applica direttamente a Q e K senza parametri aggiuntivi


**[SLIDE 2 - Come funziona]**
Il workflow di XMainframe si articola su tre task principali di output: complexity assessment, code explanation in linguaggio naturale, e refactoring suggestions.
Ma il vero valore aggiunto sta nel come questo modello è stato costruito. Gli autori identificano tre gap fondamentali nei LLM esistenti per mainframe modernization:
Primo: limited training on mainframe languages. I CodeLLM esistenti sono addestrati su un ampio spettro di linguaggi, ma la quantità di codice COBOL disponibile online è insufficiente per un apprendimento adeguato. Inoltre, le organizzazioni tendono a mantenere private le loro codebase mainframe per requisiti di security del settore finanziario. 
Secondo: lack of proper benchmarks. Prima di XMainframe non esisteva un benchmark standardizzato per valutare la conoscenza mainframe dei LLM.
Terzo: complexity beyond code generation. La modernizzazione mainframe richiede molto più che generare codice COBOL — le organizzazioni vogliono migrare i loro sistemi verso altri linguaggi, quindi i LLM devono possedere conoscenza che va oltre la pura code generation.
Questi use case — comprensione del codice e valutazione della migrazione — si inseriscono nella fase di code comprehension del ciclo di modernizzazione, che in letteratura è identificata come responsabile del 40-60% dell'effort totale di un progetto di migrazione.


**[SLIDE 3 - Varianti del modello e Training]**

"Partiamo dal training data, che è il cuore del contributo. Il Mainframe-Training Dataset consiste di 236 milioni di token provenienti da documentazione sulla tecnologia mainframe e costrutti COBOL GitHub, raccolti attraverso due canali: GitHub API per progetti COBOL open-source e web scraping di documentazione ufficiale.
Ma il dato più interessante riguarda il Mainframe-Instruct Dataset, costruito con una pipeline in 5 step:

Step 1: 300 seed data instances annotate manualmente da domain expert
Step 2: Data augmentation tramite LLM commerciali per arricchire il dataset
Step 3-5: Filtering, validation e quality assurance

Nel pre-training, combinano il Mainframe-Training Dataset con SlimOrca-Dedup — questo è fondamentale per preservare le capability generali del modello ed evitare catastrophic forgetting durante il domain adaptation.
Riguardo alle tre varianti:
Il BASE-7B è il checkpoint pre-trained senza instruction tuning. È pensato per organizzazioni che hanno dataset COBOL proprietari e vogliono fare ulteriore fine-tuning. In contesti enterprise questo è lo scenario più comune, dato che il codice COBOL contiene business logic sensibile che non può essere esposta a modelli esterni.
L'INSTRUCT-7B è la versione instruction-tuned, pronta per deployment in IDE come VS Code extension o come backend di chatbot interni.
L'INSTRUCT-10.5B è dove sta l'innovazione architetturale più interessante. XMainframe 10.5B è espanso da DeepSeek-Coder 7B attraverso il metodo di depth up-scaling, senza introdurre moduli aggiuntivi o meccanismi di dynamic expert selection GitHub — quindi niente Mixture-of-Experts.
Esperimenti precedenti hanno dimostrato che i modelli scalati in profondità inizialmente performano peggio rispetto ai loro corrispettivi base. Tuttavia, il metodo di depth-wise scaling isola l'eterogeneità nel modello scalato, permettendo un rapido recupero delle performance. arXiv Questo è esattamente quello che osservano gli autori: dopo il continued training sul Mainframe-Training Dataset e il fine-tuning sul Mainframe-Instruct Dataset, il modello 10.5B supera significativamente la versione 7B."

**Depth up-scaling**
Duplichi i layer esistenti del transformer e li impili verticalmente.
In pratica, se hai un modello con 32 layer:
Prendi alcuni layer (es. gli ultimi 16)
Li duplichi
Li concateni al modello originale
Ottieni un modello con 48 layer
Il modello 10.5B di XMainframe è ottenuto così: partono da DeepSeek-Coder 7B e aggiungono layer duplicati.
Il problema del depth scaling
Quando duplichi i layer, inizialmente il modello performa peggio del modello base. Perché? I layer duplicati sono identici agli originali, ma il modello non è stato addestrato a usarli in sequenza così lunga. C'è "eterogeneità" nel flusso di informazione.
Perché funziona comunque?
La ricerca citata (Kim et al., 2023) ha scoperto che questa eterogeneità si isola e si risolve rapidamente con un po' di training aggiuntivo. Dopo poche epoche di continued training, il modello scalato recupera e supera le performance del modello base.



**[SLIDE 3 - Benchmark]**

"Gli autori introducono MainframeBench, che è disponibile pubblicamente su HuggingFace — questo è un contributo importante perché prima non esisteva un benchmark standardizzato per questo dominio.
MainframeBench comprende tre subtask:
Multiple Choice Questions — per valutare la conoscenza fattuale sui mainframe
Question Answering — per valutare la capacità di reasoning
COBOL Code Summarization — per valutare la comprensione del codice
La tabella che vedete mostra i risultati sul task di summarization. XMainframe-Instruct 10.5B raggiunge un BERTScore di 0.96 contro 0.88 di GPT-3.5, un RougeL di 0.74 contro 0.28, e un BLEU-4 di 62.58 — circa sei volte superiore rispetto a GPT-3.5 e nove volte rispetto a GPT-4.
Sulle multiple-choice questions, XMainframe supera DeepSeek-Coder con un incremento del 30% in accuracy. Sul question answering, raggiunge un BLEU score di 22.02, che è il doppio di Mixtral-Instruct 8x7B e cinque volte meglio di DeepSeek-Coder-Instruct 33B. 
Un aspetto metodologico importante: la valutazione è stata condotta con zero-shot prompting e temperatura fissata approssimativamente a 0, favorendo l'exploitation della conoscenza del modello rispetto all'exploration. 
C'è però un insight qualitativo interessante che spiega questi numeri: gli sviluppatori tendono a preferire summary concisi e comprensivi per le funzioni COBOL rispetto a quelli prolissi. XMainframe-Instruct ha la capacità di riconoscere e applicare questa osservazione, producendo summary concisi. Al contrario, altri LLM spesso generano risposte più lunghe che non si allineano alle preferenze degli sviluppatori. "









### 4.2 Migration Exp

[SLIDE 1 - Introduzione]
"MigrationExp è un Decision Support System per la migrazione incrementale di applicazioni, pubblicato su Information and Software Technology nel 2023. Il contributo principale è l'applicazione di tecniche di Learning-to-Rank per raccomandare l'ordine ottimale di migrazione dei file.
Ma prima di entrare nel dettaglio tecnico, voglio contestualizzare perché questo problema è rilevante.
In letteratura si distinguono due strategie di migrazione: la one-step migration (o Big Bang), dove si riscrive tutto da zero, e la incremental migration (o Chicken Little), dove si migra gradualmente file per file. La migrazione incrementale ha vantaggi significativi: il rischio è controllabile, se uno step fallisce si ripete solo quello, e le risorse richieste sono distribuite nel tempo.
Tuttavia, la migrazione incrementale introduce un problema non banale: in che ordine migro i file? La scelta sbagliata può generare errori di compilazione, runtime exceptions, o richiedere workaround costosi.
Il paper presenta un caso reale che illustra questo problema: uno sviluppatore stava migrando un'applicazione Vaadin da Java a Kotlin. Ha scoperto che migrando Review.java prima di Category.java, l'applicazione compilava ma crashava a runtime con un'eccezione di tipo InvalidTemplateModelException. Invertendo l'ordine — migrando prima Category.java — tutto funzionava correttamente. Come ha scritto lo stesso sviluppatore: questi errori sono dovuti alla mancanza di una strategia di migrazione ottimale.
MigrationExp nasce per risolvere esattamente questo problema: dato un progetto da migrare, suggerisce quali file migrare prima basandosi su pattern appresi da migrazioni reali.


[SLIDE 2 - Training Phase e Serving Phase]
"L'architettura di MigrationExp si articola in due fasi distinte: Development Phase e Serving Phase.
Development Phase — Come si costruisce il modello
Il training data proviene da progetti open-source che hanno effettuato migrazioni da Java a Kotlin. Gli autori hanno costruito due dataset:

GitHubj2k: 1179 progetti, 7275 commits con migrazioni, 27.375 file migrati — usato per il training
Androidj2k: 266 applicazioni Android da FAMAZOA, 3118 commits, 8754 file migrati — usato per il testing

Questa separazione è importante: evita il classico problema dell'overfitting da cross-validation, dove si assume di conoscere già il 90% del dominio.
Per ogni commit con migrazione, il sistema:

Estrae le features da tutti i file Java presenti in quel commit
Etichetta i file come migrated (1) o not migrated (0)
Crea una query nel formato Learning-to-Rank

Le features estratte sono 56 metriche raggruppate in categorie:

Size: SLOC, numero di metodi, numero di campi
Complexity: WMC (Weighted Method per Class), max nested blocks
Coupling: CBO (Coupling Between Objects), RFC (Response For a Class)
Cohesion: LCOM, TCC, LCC
Inheritance: DIT (Depth Inheritance Tree)
Readability: numero di loop, assignment, comparisons, string literals
Android-specific: 12 metriche come isActivity, isView, isFragment, isBroadcastReceiver
Java-specific: numero di static methods, inner classes, lambdas, anonymous classes

Perché Learning-to-Rank?
Gli algoritmi di Learning-to-Rank si dividono in tre approcci: pointwise, pairwise e listwise.
Il pointwise considera ogni documento (file) indipendentemente — ma nella migrazione, la decisione di migrare un file dipende dal contesto del progetto.
Il pairwise considera coppie di documenti: dato il commit C, il file F₁ che è stato migrato deve essere rankato più in alto del file F₂ che non è stato migrato. Questo cattura la decisione relativa dello sviluppatore.
Il listwise considera l'intera lista, ma è più complesso da ottimizzare.
Gli autori scelgono l'approccio pairwise con LambdaMART, un algoritmo sviluppato da Microsoft basato su gradient boosted decision trees. LambdaMART è stato dimostrato essere tra i best-performing su benchmark pubblici di information retrieval. L'implementazione usa XGBoost come backend.
Serving Phase — Come si usa il modello
Dato un progetto P da migrare, con N file Java candidati:

Si estraggono le stesse 56 features per ogni file
Si crea una query con N vettori di features (senza label)
Il modello assegna un predicted relevance score a ogni file
Si ordina per score decrescente → i file in cima sono quelli da migrare prima"


[SLIDE 3 - Use Case Simple Calendar Pro]
"Vediamo un esempio concreto: Simple Calendar Pro, un'applicazione Android con oltre 100.000 download su Google Play.
L'app è stata completamente migrata da Java a Kotlin in 2 mesi, attraverso 202 commits incrementali — un caso reale di Chicken Little migration.
Consideriamo la versione al commit 2d1c59: 38 file già migrati in Kotlin, 6 file Java ancora da migrare.
MigrationExp analizza i 6 file candidati e produce questo ranking:
FilePredicted RelevanceActual MigrationAboutActivity.java0.96✓ MigratoMyWidgetProvider.java0.58—WidgetConfigureActivity.java0.42—Utils.java0.32—LicenseActivity.java0.27—Constants.java-0.24—
Il modello assegna il punteggio più alto (0.96) a AboutActivity.java, che è esattamente il file che lo sviluppatore ha effettivamente migrato nel commit successivo. MAP@1 = 1 — predizione perfetta.
Nota interessante: questo ordine contraddice la guideline ufficiale di Google, che suggerisce di migrare prima le utility classes (come Utils.java) e poi le Activity. Il modello ha imparato dai dati che gli sviluppatori reali non seguono necessariamente quella guideline."

[SLIDE MANCANTE - Risultati Quantitativi] (ti suggerisco di aggiungerla)
"I risultati della valutazione mostrano le performance del modello in termini di Mean Average Precision at K (MAP@K):
StrategiaMAP@1MAP@5MAP@10Random0.1880.2680.278Google's Guideline0.1080.1900.202MigrationExpJ2K0.2250.2930.308
L'improvement rispetto alla baseline Random è del 10-20%. Ma il dato più significativo è l'improvement rispetto a Google's guideline: +108% a k=1, e oltre il 50% per tutti i valori di k.
Questo suggerisce che le guideline ad alto livello di Google — migrare prima data classes, poi test, poi utility — non riflettono il comportamento reale degli sviluppatori.
Riguardo alla feature importance calcolata da XGBoost, le features più influenti sono:

isView (gain: 29.54)
isBroadcastReceiver (gain: 8.05)
isService (gain: 7.98)
isContentProvider (gain: 6.28)

Questo indica che il modello basa le sue decisioni principalmente sul tipo di componente Android — un'informazione che le guideline generiche non catturano."

[CLOSING - Considerazioni critiche e rilevanza per COBOL]
"Gli autori stessi riconoscono che c'è room for improvement: MAP@10 = 0.308 è lontano dal valore ideale di 1.0. Le direzioni future includono:

Hyperparameter tuning di XGBoost
Data balancing con tecniche come SMOTE
Feature engineering aggiuntivo, ad esempio metriche di coupling tra file già migrati e non migrati
Interpretabilità: integrazione con SHAP per spiegare perché un file è suggerito

Rilevanza per la migrazione COBOL
Sebbene il paper si focalizzi su Java→Kotlin, l'approccio è language-agnostic. La metodologia può essere adattata a migrazioni COBOL→Java definendo:

Feature set appropriato (metriche COBOL-specific invece di Android-specific)
Training data da progetti enterprise migrati
Considerazione delle dipendenze tra programmi COBOL, copybook, e JCL

Il valore principale per il nostro contesto è dimostrare che un approccio data-driven basato su Learning-to-Rank può superare le guideline manuali, catturando pattern impliciti nelle decisioni degli sviluppatori esperti.

---

## 5. TRADUZIONE AUTOMATICA DEL CODICE CON LLM (6-7 min)

### 5.1 Traduzioni Transitive: InterTrans
**Contenuto della slide:**

 InterTrans fa traduzione automatica diretta - prende codice in un linguaggio e lo converte in un altro.L'idea chiave è l'uso di linguaggi intermedi. Invece di tradurre direttamente da linguaggio A a linguaggio B - che è difficile per gli LLM - InterTrans traduce passando attraverso uno o più linguaggi intermedi che fungono da 'ponte'.Per esempio, per tradurre da Python a Java, potrebbe passare attraverso C++: Python → C++ → Java. Questo approccio contro-intuitivo si rivela più accurato della traduzione diretta



"Il funzionamento di InterTrans si basa su tre step fondamentali.
Step 1: Tree of Code Translation (ToCT). L'algoritmo costruisce un albero di tutti i possibili percorsi di traduzione tra il linguaggio sorgente e quello target. Guardate il diagramma: se vogliamo tradurre da Python a Java, possiamo andare diretti oppure passare attraverso Rust, JS, C++, o Go. L'albero esplora sistematicamente tutte queste possibilità.
Step 2: Exploration. Per ogni percorso nell'albero, un LLM genera la traduzione. Nota importante: InterTrans usa LLM pre-trained as-is - non serve training aggiuntivo. Funziona con Code Llama, Magicoder, StarCoder2, o qualsiasi altro code LLM.
Step 3: Validation con test suite. Questo è il punto cruciale. L'algoritmo esplora i percorsi fino a trovare una traduzione che passa tutti i test. Appena trova una traduzione corretta, si ferma. Questo è un approccio test-driven: la correttezza è verificata automaticamente.
Il percorso evidenziato in verde nel diagramma mostra un esempio di successo: Python → Rust → Java è stato il percorso vincente per quel particolare problema."

Vediamo gli use case concreti dove InterTrans si è dimostrato efficace.
Il primo esempio è Python → C++ → Java. Tradurre direttamente da Python a Java è difficile per gli LLM perché i paradigmi sono molto diversi. Ma passando attraverso C++ - che ha tipizzazione statica come Java ma sintassi più vicina a Python - il processo diventa più accurato.
Il secondo caso è C++ → Rust → Java. Rust funziona bene come linguaggio intermedio perché condivide con C++ la gestione della memoria low-level, ma ha costrutti più moderni simili a Java.
Il terzo esempio è particolarmente rilevante per noi: COBOL → C → C++ → Java. Questo è un percorso multi-step che passa attraverso due linguaggi intermedi. COBOL è tradotto prima in C (entrambi procedurali), poi C in C++ (aggiunge OOP), infine C++ in Java.
Guardiamo ora i risultati del benchmark. La tabella confronta tre LLM popolari in modalità direct translation versus con InterTrans.
Code Llama: accuracy passa da 50-60% a 70-80% - un miglioramento del 20-30%.
Magicoder: è il vincitore assoluto. Direct translation ottiene già 60-70%, ma con InterTrans sale a 87.3-95.4%. Questo è quasi perfetto - significa che 9 traduzioni su 10 passano tutti i test.
StarCoder2: da 55-65% a 75-85%, +20-30% di miglioramento.
Il messaggio chiave è che InterTrans migliora qualsiasi LLM senza bisogno di training aggiuntivo. È una tecnica plug-and-play che funziona con modelli off-the-shelf."



### 5.2 Code Reborn



### 5.3 GPT-MIGRATE

Da rimuovere


---
## 6. TOOL AUTOMATICI BASATI SU AI

### 6.1 Microsoft CAMF - COBOL Agentic Migration Factory 

"Microsoft CAMF - COBOL Agentic Migration Factory - è un framework open-source sviluppato da Microsoft per la modernizzazione di sistemi mainframe COBOL.A differenza di XMainframe che si limita a spiegare il codice, o MigrationExp che suggerisce l'ordine di migrazione, CAMF esegue la traduzione completa end-to-end da COBOL a Java Quarkus, producendo codice production-ready.Il framework è stato sviluppato in collaborazione con Bankdata, un consorzio di 8 banche danesi che gestisce oltre 70 milioni di linee di codice COBOL. Questa partnership è stata fondamentale perché ha fornito accesso a codice COBOL enterprise reale, non solo esempi semplificati da GitHub.CAMF è costruito su Microsoft Semantic Kernel, un framework per orchestrare agenti AI. La tecnologia di base è GPT-4.1, scelto specificamente per le sue capacità di reasoning - la capacità di analizzare logicamente la struttura del codice COBOL, seguire decision paths e comprendere control flow.Il framework è completamente open-source e disponibile su GitHub all'indirizzo Azure-Samples/Legacy-Modernization-Agents. Questo è importante perché permette alle organizzazioni di mantenere il controllo del proprio intellectual property, evitando dipendenza da vendor esterni o Global System Integrators.La data di pubblicazione è luglio 2025, quindi è un tool molto recente - pubblicato tramite blog post su Microsoft DevBlogs. Non è un paper accademico peer-reviewed, ma un progetto enterprise open-source con documentazione tecnica completa.Un aspetto critico da sottolineare: CAMF NON fa training di modelli custom. Usa GPT-4.1 pre-trained in modalità zero-shot, affidandosi completamente a prompt engineering e orchestrazione multi-agente per ottenere risultati di qualità.

"L'architettura di CAMF si basa su un orchestratore centrale chiamato MigrationProcess.cs che coordina tre agenti specializzati. 
AGENT 1: COBOLAnalyzerAgent è il parsing engine fondamentale. La sua funzione è trasformare codice COBOL non strutturato in dati di analisi strutturati e machine-readable. Tecnicamente, riceve file COBOL raw come input ed esegue un'analisi semantica profonda usando AI per estrarre: la struttura del programma e le data divisions, le definizioni di variabili e le loro gerarchie, il flusso procedurale e la business logic, gli statement SQL/DB2 embedded, e le dipendenze da copybook. L'implementazione usa execution settings ottimizzati: MaxTokens di 32,768 per gestire programmi legacy di grandi dimensioni, Temperature di 0.1 per garantire analisi deterministica, e TopP di 0.5 per output focalizzato. L'output è un oggetto CobolAnalysis strutturato che contiene tutte queste informazioni in formato parsabile.

AGENT 2: DependencyMapperAgent funziona come il 'cervello architetturale' del framework. Analizza le relazioni tra programmi COBOL, costruisce mappe di dipendenze e reverse dependencies, e genera diagrammi Mermaid per visualizzare queste relazioni. Usa un approccio dual-prompt molto intelligente. Il primo prompt genera diagrammi Mermaid flowchart che mostrano visivamente le relazioni tra programs e copybooks, usando subgraphs per raggruppare componenti correlati, colori diversi per programmi versus copybooks, e frecce direzionali per indicare data flow e pattern di inclusione copybook. Il secondo prompt esegue analisi AI-powered che identifica: data flow dependencies tra copybooks, potenziali circular dependencies, raccomandazioni di modularità, e legacy patterns che impattano le dipendenze. Calcola anche metriche quantitative: totale programs, totale copybooks, e media dependencies per program. Questo context architetturale è essenziale perché alimenta sia il COBOLAnalyzerAgent - fornendo usage patterns, data flow, e problematic patterns - sia il JavaConverterAgent - suggerendo dove definire microservice boundaries in Quarkus, come mappare COBOL data structures a Java entities, e quali component devono comunicare nella nuova architettura.

AGENT 3: JavaConverterAgent è il motore di trasformazione core che converte codice COBOL in Java Quarkus production-ready. Il system prompt è critico e specifica: creare proper Java class structures da COBOL programs, convertire COBOL variables in appropriate Java data types, trasformare COBOL procedures in Java methods, e - fondamentale - gestire COBOL-specific features come PERFORM loops e GOTO statements in modo idiomatico Java moderno. Lo Step 4 del prompt è particolarmente importante: sostituire PERFORM statements con loop strutturati for, while, do-while o method calls, eliminare GOTO ristrutturando la logica con if-else, switch-case, loops o metodi chiaramente definiti, assicurando che il codice Java risultante sia readable, maintainable, e segua current best practices invece di replicare direttamente la struttura COBOL - evitando il cosiddetto 'JOBOL', Java che sembra COBOL. Include feature enterprise-grade: retry logic con exponential backoff per gestire timeout e content filter violations, content sanitization che pulisce automaticamente testo internazionale per evitare trigger di Azure OpenAI content filters, e code extraction che parsa intelligentemente Java generato da AI estraendolo da markdown blocks. L'output è un oggetto JavaFile con modern Java Quarkus code, proper annotations, struttura microservice-ready, business logic preservata, e enterprise design patterns applicati.L'orchestrazione funziona in sequenza pulita: primo, scopri file COBOL e copybooks, secondo, analizza file COBOL per struttura e logica via COBOLAnalyzerAgent, terzo, mappa dependencies program-to-copybook e altro via DependencyMapperAgent, quarto, converti programmi COBOL in Java usando analisi e dependency context via JavaConverterAgent salvando ogni classe, e quinto, genera reports e diagrams basati su dependency analysis. Ogni agente ritorna structured outputs che servono come input per il next agent nella pipeline - questo garantisce clean separation of concerns, testabilità, ed estensibilità.L'output finale comprende: Generated Java Code pronto per deployment, e Reports & Diagrams che includono dependency diagrams in formato Mermaid, full chat log di tutte le agent conversations per transparency e debug, conversion metrics con statistiche su programs/copybooks processati, e compliance reports

"CAMF utilizza una pipeline tri-fasica che prepara il codice COBOL prima di tentare la conversione. Questa preparazione è fondamentale per il successo della migrazione.
FASE 1: PREPARATION si concentra sul preparare il codice COBOL per la comprensione AI.
Il primo step è Reverse Engineering. Questo non significa solo leggere il codice sorgente, ma estrarre l'essenza della business logic da multiple fonti: il codice stesso ovviamente, ma anche commenti esistenti nel codice che possono contenere informazioni preziose, documentazione tecnica che potrebbe esistere in formato cartaceo o PDF, user handbooks che spiegano come il sistema viene utilizzato dagli utenti finali, e crucialmente, Subject Matter Experts umani - i developer veterani che hanno lavorato sul sistema per decenni e detengono knowledge tribale non documentata. L'output di questo step è una comprensione completa del 'cosa fa' il sistema, non solo del 'come' è implementato.
Il secondo step è Code Cleaning. L'obiettivo è rimuovere noise dal codice che non aggiunge valore per l'AI ma consuma context window prezioso. Questo include: rimuovere commenti inutili come change logs estesi negli header dei file - spesso i file COBOL legacy hanno centinaia di linee di commenti che documentano ogni modifica fatta negli ultimi 30 anni, questi non aiutano l'AI a capire la logica corrente. Eliminare informazioni non-value per context come boilerplate standard, dichiarazioni ripetitive, o sezioni di codice comentate che non sono più in uso. L'idea è: meno noise, più signal per l'AI.
Il terzo step è Translation, ed è particolarmente importante nel caso Bankdata. Il loro codice COBOL era scritto in Danese - commenti, nomi di variabili, tutto in lingua danese. Questo è un problema perché GPT-4, pur essendo multilingue, è stato primarily trained su codice in inglese. Le sue performance calano significativamente su linguaggi naturali 'niche' come il danese quando applicati a code understanding. La soluzione: tradurre tutto il codice e i commenti in inglese prima di passarlo all'AI. Questo può sembrare un overhead, ma migliora drasticamente l'accuracy della conversione finale.
FASE 2: ENRICHMENT fa l'opposto di cleaning - aggiunge context semantico che aiuta l'AI.
Il primo step è Add Meaningful Comments. Sembra contraddittorio dopo aver fatto cleaning, ma la differenza è qualità vs quantità. I commenti buoni AIUTANO l'AI. Per esempio, aggiungere commenti che spiegano: 'questo blocco implementa il calcolo interessi composti secondo la formula Basel III' è molto più utile che avere 50 linee di change log. Particolarmente efficace è usare Markdown ben-strutturato, specialmente se questo markdown è stato generato da AI in un pass precedente - gli LLM tendono a comprendere meglio il proprio output formatting.
Il secondo step è Identify Deterministic Structures. Il codice COBOL spesso ha pattern ricorrenti: stesso stile di error handling ripetuto 100 volte, stesso pattern di file I/O in ogni program, stesse convenzioni di naming. Identificare questi pattern permette all'AI di: applicare transformations consistenti, fare chunking intelligente del codice - processare blocchi simili insieme, e riconoscere 'idioms' COBOL che hanno equivalenti diretti in Java.
Il terzo step è Document Temporary Results. Durante l'analisi, l'AI genera insights intermedi - per esempio, 'questo modulo gestisce validazione customer data'. Salvare questi insights in markdown files intermedi e riutilizzarli come context in step successivi crea una sorta di 'memoria' per la pipeline. Questo è particolarmente utile per mantenere consistency quando si processano molti file correlati.
L'obiettivo complessivo di queste due fasi è arrivare alla Fase 3 con codice COBOL 'AI-ready': pulito da noise, arricchito con context semantico utile, tradotto in inglese, e con temporary analysis già available."

La FASE 3: AUTOMATION AIDS genera artefatti e analisi che supportano la migrazione e forniscono visibilità agli stakeholder umani.
Flow Analysis & Visualization è il primo componente. Questa attività crea rappresentazioni visive delle call chains tra moduli COBOL. Per esempio, se PROGRAM-A chiama PROGRAM-B che chiama PROGRAM-C, il sistema genera un diagramma che mostra questo flow. Usa call chains esistenti quando disponibili nella documentazione, oppure li genera automaticamente analizzando CALL statements nel codice. I diagrammi sono generati in formato Mermaid - una sintassi text-based per creare diagrammi che può essere embedded direttamente in Markdown e renderizzata automaticamente in GitHub, GitLab, e molti altri tools. Alternativamente usa flowcharts tradizionali. Questi diagrammi servono principalmente come supporto per human engineers - permettono di capire rapidamente l'architettura del sistema senza dover leggere migliaia di linee di codice. Sono particolarmente utili durante code review per verificare che la conversione Java abbia mantenuto lo stesso flow logico.
Test Generation è forse il componente più importante per garantire quality. Se esistono test files per i programmi COBOL originali, CAMF può: analizzare questi test per capire expected behavior, convertirli in JUnit test equivalenti per il codice Java generato, oppure espanderli aggiungendo edge cases che potrebbero non essere stati coperti originariamente. Se non esistono test, il sistema può sperimentare con un approccio Test-Driven Development: generare test basati sulla business logic estratta dal codice, usare questi test per validare la conversione Java, iterare fino a quando tutti i test passano. Questo è un safety net critico: senza test, non c'è modo di verificare che il codice Java generato sia funzionalmente equivalente al COBOL originale. I test generati coprono: unit tests per singole funzioni/metodi, integration tests per interazioni tra moduli, e idealmente anche regression tests per verificare che bug fixes storici non ritornino.
Isolate Utility Functions è un'ottimizzazione importante. Molto codice COBOL include logic che oggi gestiremmo via libraries standard - per esempio, validazione date, formattazione stringhe, calcoli matematici comuni, conversioni tra formati. Il sistema identifica questi pattern: cerca funzioni che implementano logic 'utility-like', verifica se esistono equivalenti in Java standard library o librerie Quarkus comuni, e separa questa logic dal business logic core. Benefici: riduce la quantità di codice che deve essere convertito custom, riduce token usage per l'AI (meno codice da processare), e migliora maintainability del codice finale - meglio usare Math.round() che convertire una COMPUTE statement custom. Il processo produce una lista di 'utility functions detected' con suggested Java equivalents, e il codice può essere refactored per usare queste libraries invece di re-implementare tutto da zero.
L'output complessivo della Fase 3 include: Mermaid diagrams salvati in formato .mmd o embedded in documentation Markdown, generated test suites in JUnit format pronti per execution, report su utility functions identificate con mapping a Java standard libraries, e crucialmente, tutto questo è human-reviewable - non è codice finale auto-deployed, ma artefatti che gli engineers possono inspect e approve.



### 6.2 Reforge-AI
Reforge-AI opera attraverso un processo bi-fasico molto deliberato, dove ogni fase ha obiettivi chiari e deliverables specifici.
FASE 1: DOCUMENTATION è gestita dallo script Python gen_docs.py e ha come goal generare documentazione autoritativa PRIMA di toccare qualsiasi codice. Questo è il pilastro del documentation-first approach.
Tecnicamente, la fase usa una Documentation Crew composta da agenti specializzati: un Architecture Analyzer con role 'Senior Architect' che scansiona il codebase e existing Javadoc per inferire module boundaries, data flows, e integration points, un Diagram Generator con role 'Technical Writer' che crea rappresentazioni visive, un Dependency Mapper con role 'Build Engineer' che analizza le relazioni tra componenti, e un Plan Writer con role 'Migration Specialist' che sintetizza tutto in un piano eseguibile.

Il processo di Automated Architecture Capture funziona così: gli agents scansionano il codebase Java legacy identificando EJB components con annotations come @Stateless, @Stateful, @Singleton, mappano il persistence layer cercando JPA entities e DAOs, documentano REST endpoints e le loro dependencies, e creano component diagrams in sintassi Mermaid. Il focus è su: module boundaries e coupling levels, data flow tra components, e external integrations con databases e APIs.
L'output di questa fase include: sequence diagrams e component diagrams tutti in formato Mermaid che può essere embedded in Markdown, dependency graphs delle third-party libraries mostrando Maven dependencies, service catalogs con endpoint signatures documentando ogni API REST disponibile, e crucialmente un file plan.yaml che contiene il migration plan dettagliato con module prioritization, transformation strategies per ogni module, dependency order per evitare breaking changes, e risk assessment per ogni step.
Un aspetto fondamentale è l'Iterative Human-in-the-Loop Refinement. Invece di fidarsi ciecamente di un single LLM pass, Reforge-AI implementa un improvement loop: primo, AI genera documentazione e diagrams initial, secondo, engineers reviewano tutto, terzo, feedback viene fed back negli agents' prompts, quarto, agents re-renderizzano updated diagrams e text, e quinto, repeat fino ad approval. Questo loop ibrido riflette best practices in developer documentation dove visual elements sono critical per complex workflows. By the end of Phase 1, il team ha una battle-tested migration plan con rich Mermaid visuals e precise upgrade steps validati da humans.
FASE 2: CODE GENERATION è gestita dallo script gen_modern.py e usa la documentazione generata in Fase 1 come blueprint per la migrazione effettiva.
La fase usa una Gen Code Crew con agenti ultra-specializzati: il Code Conversion Agent con role 'Senior Java Developer' trasforma EJB in Spring components, sostituisce @Stateless annotations con @Service, usa constructor-based dependency injection con @Autowired invece di field injection, converte @PersistenceContext in Spring Data repositories eliminando boilerplate DAO code, aggiunge @Transactional dove necessario per transaction boundaries, e implementa proper exception handling con custom exceptions e @ControllerAdvice. Converte anche Java EE patterns in Spring Boot idioms: per esempio, servlet filters diventano Spring interceptors, EJB timers diventano @Scheduled methods, e JNDI lookups vengono rimossi in favore di dependency injection pura.
Il Dependency Update Agent con role 'Build Engineer' gestisce l'upgrade completo della base tecnologica: aggiorna Java version da 8 a 21 modificando pom.xml e source/target compatibility, migra dependencies da Java EE packages javax.* a Jakarta EE packages jakarta.*, aggiorna Spring Framework da versioni legacy a Spring Boot 3, gestisce plugin configurations modernizzando maven-compiler-plugin, spring-boot-maven-plugin settings, e risolve breaking changes in API deprecate cercando alternatives nelle nuove versioni.
Il Test Scaffolding Agent con role 'QA Engineer' crea una safety net completa: genera unit tests usando JUnit 5 invece di vecchio JUnit 4, crea integration tests con @SpringBootTest per testing end-to-end, imposta test configurations con @TestConfiguration e mock beans, e assicura che ogni method critico abbia almeno un test case.
Il Compliance Check Agent con role 'Security Specialist' è responsabile della sicurezza e quality: verifica che security annotations siano presenti come @PreAuthorize, @Secured dove necessario, applica style guides aziendali per consistent code formatting, incorpora OWASP best practices contro common vulnerabilities come SQL injection, XSS, CSRF, e valida che non ci siano hardcoded credentials o sensitive data nel codice.
Il workflow orchestrato processa one module at a time seguendo l'ordine definito nel plan.yaml. Per ogni module: legge la documentazione generata in Phase 1 come context, Code Conversion Agent trasforma il codice, Dependency Update Agent aggiorna pom.xml, Test Scaffolding Agent genera tests, Compliance Check Agent valida tutto, un Build Agent (non menzionato prima ma implicito) tenta compilation, genera build/test report, poi human review decide approve or provide feedback, se feedback gli agents iterano, finally move to next module. Questo è un processo deliberato e controllato, non una Big Bang migration.
L'output per ogni module include: clean Spring Boot services con proper Spring annotations @Service, @Repository, @RestController, updated build scripts con pom.xml modernizzato e dependencies corrette, auto-generated DTOs e mapping logic per separare presentation layer da business layer, build/test reports per ogni module mostrando compilation status e test results, e feedback sections embedded nei reports per human reviewers.

Vediamo ora il contesto d'uso concreto di Reforge-AI, gli output che produce, e le limitazioni riconosciute.

**USE CASE**: Banking Legacy Java Migration è il domain target principale. Le banche tipicamente hanno applicazioni Java enterprise sviluppate negli anni 2000-2010 con tecnologie come Java EE, EJB, JSF, Struts. Queste applicazioni contengono decadi di business logic mission-critical: calcoli di interessi composti, gestione conti correnti, processing transazioni, compliance regulatory. Il technical debt è massiccio: frameworks obsoleti non più supportati, coupling stretto tra components che rende difficile testing, e sparse documentation perché la knowledge è nella testa dei developer veterani. I migration risks sono altissimi: potential business disruption se qualcosa va storto, regression bugs in critical paths potrebbero causare perdite finanziarie, loss of institutional knowledge durante la transition, e compliance audit requirements richiedono traceability completa di ogni modifica.
Reforge-AI affronta questo con Phased Incrementalism: break migrations in logical slices come account services, transaction services, reporting modules, ogni slice segue il ciclo document → migrate → test → deploy, questo riduce risk e aligns con banking de-risking strategies. Include anche Compliance Integration: il Compliance Check Agent verifica OWASP guidelines automaticamente, inserisce security annotations dove necessario, mantiene audit trail completo tramite Git history più reports, e garantisce test coverage per ogni module per soddisfare audit requirements. Un esempio concreto: un modulo 'AccountService' con 500 linee di EJB code viene documentato, il plan.yaml specifica le transformations necessarie, il Code Conversion Agent genera Spring Boot code equivalente, i test vengono generati e eseguiti, e il tutto viene reviewato da un senior developer prima di merge.
Gli OUTPUT sono completi e multi-livello.
La Architecture Documentation include: component diagrams in Mermaid mostrando services e loro relationships, sequence diagrams per key user flows come login, transaction processing, dependency graphs delle Maven dependencies con versioni attuali e target, e module boundaries map che identifica bounded contexts per eventual microservices decomposition.
I Migration Plans sono il file plan.yaml che contiene: module prioritization con high/medium/low urgency, transformation strategies dettagliate per ogni module tipo ejb_to_spring, rest_controller, jpa_repository, dependency order per garantire che modules siano migrati in ordine sicuro evitando broken builds, e risk assessment per ogni step identificando high-risk changes che richiedono extra scrutiny.
La Module Analysis fornisce per-module detailed analysis: business logic extraction spiegando in plain language cosa fa ogni module, API contracts documentation con input/output schemas, integration points identificando databases, external APIs, message queues, e data flow maps mostrando come i dati fluiscono attraverso il sistema.
Il Modernized Code è production-ready: Spring Boot services con @Service, @Repository, @RestController annotations appropriate, updated pom.xml files con Java 21 e Spring Boot 3 dependencies, configuration files come application.yml con database connections e properties, e proper package structure seguendo best practices Spring Boot.
I Generated Tests includono: unit tests con JUnit 5 usando @Test, @ParameterizedTest, integration tests con @SpringBootTest per end-to-end scenarios, e test configuration con @TestConfiguration e mock beans per isolation.
I Reports prodotti sono: build logs per ogni module mostrando se la compilation è successful, test reports con coverage percentages e failed test details, conversion metrics come total modules processed, lines of code migrated, complexity reduction, e compliance validation reports confermando che security requirements sono soddisfatti.
Infine, Feedback and Suggestions sono embedded in ogni document: per ogni document/module ci sono checkpoints dove human reviewers possono approve or reject, section per capture notes e improvement ideas, e approval workflow che traccia chi ha reviewato cosa e quando.
Le LIMITAZIONI riconosciute sono importanti da capire.
Costi elevati con API GPT-4: ogni module migration richiede multiple API calls a GPT-4, la Fase 1 documentation per un progetto medio può costare centinaia di dollari in API fees, e la Fase 2 code generation moltiplica questo costo per numero di modules. Per progetti enterprise con centinaia di modules, i costi possono diventare proibitivi. Una soluzione parziale è usare modelli più economici come GPT-3.5-turbo per tasks semplici, ma questo può ridurre quality.
Specializzato in Java Legacy: Reforge-AI è ottimizzato specificamente per Java EE to Spring Boot migrations. Non supporta altri linguaggi come COBOL, Python, .NET. Non supporta altri target frameworks come Micronaut o Quarkus (anche se teoricamente adattabile). Questo significa che per una migration strategy multi-language, serve combinare con altri tools.
Build Agent Hallucinations: questo è un problema comune con LLM-based tools. Il Build Agent che simula build logs può essere inaccurato: potrebbe riportare 'build successful' quando in realtà ci sono compilation errors, oppure riportare test failures che non esistono. Questo richiede human verification: sempre eseguire build reali con Maven, sempre eseguire test suite complete, e mai fidarsi ciecamente dei reports generati dall'AI. Il monitoring via Langtrace (uno strumento di observability per LLM applications disponibile su app.langtrace.ai) può aiutare a identificare quando l'AI sta hallucinating.
Altre limitazioni dal README GitHub includono: hardcoded paths nel codice che richiedono manual changes, inconsistent model outputs dove running gen_docs.py multiple volte produce different results, agent tool errors dove il LLM sometimes refuses to read documents per problemi di tool selection, e inability to delete folders richiedendo manual cleanup.
Nonostante queste limitazioni, Reforge-AI dimostra che l'approccio agentic con documentation-first può drastically ridurre lo sforzo manuale in migrations enterprise-scale, anche se human oversight rimane assolutamente essential.

---

## 7. VALIDAZIONE E TESTING AUTOMATICO (4 min)

**Contenuto della slide:**
Framework IBM per validazione automatica trasformazioni COBOL→Java. Pipeline: (1) Symbolic execution genera input per paragrafi COBOL coprendo tutti i path logici (IF, EVALUATE, PERFORM), (2) Esecuzione COBOL su mainframe con mocking di risorse esterne (Db2, CICS, IMS, file), (3) Generazione automatica test JUnit equivalenti per Java, (4) Confronto output per verificare equivalenza funzionale. Già integrato in Watsonx Code Assistant for Z. Scalabile su enterprise codebase, raggiunge elevati branch coverage, riduce drasticamente tempo validazione vs approccio manuale. Ogni path rappresenta una traiettoria di esecuzione determinata dai rami logici: il framework assicura che tutte le varianti logiche siano validate, identificando errori nella traduzione Java.

---

## 8. RAPPRESENTAZIONI INTERMEDIE E METAMODELLI (5 min)

### 8.1 Evoluzione: Da AST a Data Flow Graph
**Contenuto della slide:**
GraphCodeBERT introduce data flow graph come alternativa efficiente agli AST nel pre-training. Il data flow codifica relazioni semantiche "da-dove-viene-il-valore" tra variabili: struttura più compatta, gerarchie meno profonde, maggiore efficienza computazionale rispetto agli AST tradizionali. StructCoder implementa encoder-decoder structure-aware che analizza sia AST che Data Flow Graph nell'encoder, e predice AST paths e data flow nel decoder. Questo obbliga il modello a "ragionare" sulla struttura durante la generazione.

### 8.2 Ottimizzazione Input: AST-Trans
**Contenuto della slide:**
AST-Trans affronta il problema dell'input length negli AST linearizzati (molto più lunghi del codice) e complessità O(N²) dell'attention standard. Soluzione: focus solo su relazioni critiche (ancestor-descendant per gerarchia, sibling per ordine operazioni) tramite matrici di relazione genitore-figlio e fratello-fratello. Risultati superiori vs AST standard in code summarization. Implicazione per migrazione: questi approcci possono essere integrati in architetture LLM custom per ottimizzare processamento di rappresentazioni strutturali del codice legacy.

---

## 9. APPROCCI MODULARI: Dynamic Language Product Lines (3 min)

**Contenuto della slide:**
Dynamic Language Product Lines (DLPL) applicano concetti di software product line ai linguaggi di programmazione. DLPL = insieme di varianti linguistiche ricombinabili dinamicamente a runtime. Micro-linguaggi = moduli che implementano funzionalità/domini specifici, sviluppabili e testabili indipendentemente. Esempio COBOL→Java: micro-linguaggio per calcolo interessi, micro-linguaggio per gestione conti, micro-linguaggio per reportistica moderna. Implementazione Neverlang: combina micro-linguaggi a runtime per supportare codice legacy e nuove estensioni simultaneamente. Vantaggio: migrazione graduale senza riscrittura completa, coesistenza legacy-moderno, testing incrementale. Non è un tool di conversione ma una metodologia architetturale per guidare modernizzazione modulare.

---

## 10. BENCHMARK E VALUTAZIONE (3 min)

**Contenuto della slide:**
CodeXGLUE (Microsoft Research 2021) resta benchmark fondamentale: 10 task diversificati, 14 dataset, 4 scenari (code-code, text-code, code-text, text-text), copertura di Java/Python/C#/PHP/JavaScript/Ruby/Go/C/C++. Task includono: clone detection (BigCloneBench 900K samples), defect detection (Devign), code completion (PY150, GitHub Java Corpus), code repair (Bugs2Fix), code translation Java↔C# (10K training), NL code search, text-to-code generation (CONCODE 100K), code summarization. Fornisce baseline BERT-style (CodeBERT), GPT-style (CodeGPT), Encoder-Decoder. Metriche standardizzate: BLEU, exact match, CodeBLEU per translation; accuracy per classification; MRR per retrieval. Standard de-facto per valutazione modelli pre-trained. Necessari nuovi benchmark per COBOL/mainframe specifici (vedi MainframeBench).

---

## 11. CONCLUSIONI E RACCOMANDAZIONI (3-4 min)

**Contenuto della slide:**
La migrazione di sistemi legacy è un problema complesso che richiede approcci multi-dimensionali. Non esiste soluzione universale: la scelta dipende da criticità sistema, budget, expertise disponibile, tolleranza al rischio. **Approccio raccomandato:** (1) Assessment approfondito con tool di analisi dinamica per capire cosa il sistema fa realmente, (2) Strategia incrementale (Strangler Fig) per ridurre rischi, (3) Scomposizione intelligente basata su analisi automatica per identificare boundary ottimali, (4) Utilizzo LLM specializzati (XMainframe, CAMF) per accelerare traduzione mantenendo qualità, (5) Testing automatico estensivo per garantire equivalenza funzionale, (6) Revisione umana sistematica su decisioni architetturali e codice mission-critical. Lo stato dell'arte offre strumenti potenti ma non sostituisce competenza di dominio: la modernizzazione è una partnership tra automazione AI ed expertise umana. Investimento in queste tecnologie può ridurre significativamente costi e tempi, ma richiede pianificazione attenta e commitment organizzativo.

---

## APPENDICE: Risorse e Repository
