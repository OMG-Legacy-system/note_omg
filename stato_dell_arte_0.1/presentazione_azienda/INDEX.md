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


[SLIDE 1 - Introduzione]

INTERTRANS è un approccio di code translation basato su LLM che sfrutta traduzioni intermedie transitive per migliorare l'accuratezza della traduzione automatica di codice. È stato presentato come conference paper nel 2025 da Macedo et al. (Queen's University, Huawei Canada, University of Waterloo).L'intuizione chiave deriva dalla machine translation per linguaggi naturali: tradurre tra certe coppie di lingue è più facile che tra altre. Per migliorare traduzioni difficili, una strategia comune è usare una pivot language — ad esempio, la traduzione statistica tra francese e tedesco spesso passa attraverso l'inglese come ponte.Perché questo è rilevante per il code translation? Studi recenti mostrano che anche i LLM soffrono di questo problema. Pan et al. (2024) hanno dimostrato che l'80% degli errori nella traduzione C++→Go sono dovuti a differenze sintattiche e semantiche, mentre solo il 23.1% degli errori si verifica traducendo C++→C. Questo suggerisce che certi linguaggi sono naturalmente più vicini tra loro.INTERTRANS sfrutta questa osservazione: invece di tradurre direttamente Python→Java, potrebbe essere più efficace tradurre Python→Rust→Java, usando Rust come bridge language che condivide caratteristiche con entrambi.A differenza di TransCoder-IR, che usa una rappresentazione intermedia a livello di compilatore (LLVM IR), INTERTRANS usa linguaggi di programmazione esistenti come intermediari, sfruttando le capability multilingue dei code LLM già pre-trainati su decine di linguaggi."


[SLIDE 2 - Tree of Code Translation]

"L'architettura di INTERTRANS si articola in due stage.
Stage 1: Tree of Code Translations (ToCT)
ToCT è un algoritmo di planning che genera tutti i possibili path di traduzione da un linguaggio sorgente Ls a un linguaggio target Lt, dato un set di linguaggi intermedi L e un parametro maxDepth che limita la profondità dell'albero.
L'algoritmo funziona così:

Inizializza una coda Q con il linguaggio sorgente
Per ogni nodo, espande verso tutti i linguaggi intermedi L ∪ {Lt}, escludendo il linguaggio corrente (non puoi tradurre Python→Python)
Se raggiungi Lt, aggiungi il path alla lista finale
Continua fino a raggiungere maxDepth

Nota importante: il set L include il linguaggio sorgente Ls ma esclude il target Lt. Questo perché Lt deve essere sempre l'endpoint finale, mentre Ls può apparire come step intermedio (per casi dove tradurre "avanti e indietro" può semplificare il codice).
Nell'esempio della slide, per tradurre Python→Java con maxDepth=3 e L={Python, Rust, JavaScript, C++, Go}, ToCT genera path come:

[Python, Java] — traduzione diretta
[Python, Rust, Java]
[Python, C++, Java]
[Python, Rust, JavaScript, Java]
E così via...

Stage 2: Sequential Verification con Early Stopping
I path generati vengono ordinati per lunghezza crescente (shortest-first) e verificati in ordine breadth-first. Per ogni path:

Si esegue la catena di traduzioni usando l'LLM
Se il risultato finale in Lt passa la test suite → STOP, ritorna la traduzione
Altrimenti, continua con il path successivo

Due ottimizzazioni critiche:

Memoization: se due path condividono un prefisso (es. [Python, Rust, Java] e [Python, Rust, JavaScript, Java] condividono l'edge Python→Rust), il risultato intermedio viene cachato e riutilizzato
Early stopping: appena un path produce una traduzione corretta, l'algoritmo termina

Questo è fondamentale perché, dai dati sperimentali, il 75% delle traduzioni riuscite richiede al massimo 2 tentativi, e la media è di soli 3.9 tentativi — molto meno del worst-case teorico di 85 tentativi con maxDepth=4."



[SLIDE 3 - Use Case]

"Vediamo perché i path intermedi funzionano meglio con un esempio concreto dal paper.
Caso: Python→Java via Rust
Nel codice Python sorgente, l'espressione if int(number_as_string[0]) in odd_digits verifica se una cifra appartiene a una tupla di interi dispari.
La traduzione diretta Python→Java tenta di usare Arrays.asList(odd_digits).contains(). Ma c'è un problema: Arrays.asList() in Java accetta solo reference types, non primitive types. Passando un int[], si ottiene un List<int[]> (una lista contenente un singolo array), non un List<Integer>. Il codice compila ma fallisce semanticamente.
La traduzione via Rust risolve questo problema. Rust usa esplicitamente un HashSet<i32> per odd_digits. Quando questo viene tradotto a Java, l'LLM genera correttamente un Set<Integer> con Arrays.asList(1, 3, 5, 7, 9) — e il metodo contains() funziona correttamente.
Perché funziona? Rust ha un type system più esplicito e rigido di Python. Forzando l'LLM a "pensare" in termini di tipi Rust, emerge una rappresentazione intermedia più precisa che si mappa meglio su Java.
Altri pattern identificati nel paper:

C++→Java via Rust: la traduzione diretta tende a copiare sintassi C++ (es. vector[i]) che non è valida in Java. Passando per Rust, la sintassi distinta forza l'LLM a riconoscere le differenze.
Rust→Go via C++: entrambi i linguaggi supportano type inference, causando ambiguità sui tipi delle variabili locali. C++ con annotazioni di tipo esplicite (int w = ...) fornisce informazione che permette una traduzione corretta a Go.

L'esempio COBOL→C→C++→Java che avete nella slide è interessante per il nostro contesto: COBOL ha semantiche molto distanti da Java, ma C è storicamente più vicino a COBOL (entrambi procedurali, gestione memoria esplicita), e C++ fornisce il ponte verso l'OOP di Java."

[SLIDE 4 - Benchmark — CORREZIONE DEI DATI]
 Ecco i dati corretti dal paper, usando la metrica Computational Accuracy (CA) — la percentuale di traduzioni che producono output funzionalmente equivalenti al codice sorgente.
Confronto INTERTRANS vs Direct Translation (CA@10)
DatasetLLMDirect CA@10INTERTRANSImprovementCodeNetCode Llama34.6%60.8%+26.2% assolutoCodeNetMagicoder49.0%87.3%+38.3% assolutoCodeNetStarCoder241.0%84.4%+43.3% assolutoHumanEval-XMagicoder66.9%95.4%+28.6% assolutoTransCoderStarCoder273.2%93.8%+20.6% assoluto
Il best-performing è INTERTRANS con Magicoder, che raggiunge 87.3%-95.4% CA sui tre benchmark.
Confronto con SOTA sul dataset TransCoder:
ApproccioCA MediaTransCoder (unsupervised)36.2%TransCoder-IR (con LLVM IR)45.8%TransCoder-ST (con test automatici)52.2%GPT-3.586.0%UniTrans + GPT-3.587.9%INTERTRANS + StarCoder293.8%
INTERTRANS supera tutti gli approcci esistenti, incluso UniTrans con GPT-3.5 che usa test case generation e program repair — funzionalità che INTERTRANS non richiede.
Risultati dell'Ablation Study:
Effetto di maxDepth:

Da depth 1 (direct) a 2: +23.7% CA (Code Llama su HumanEval-X)
Da depth 2 a 3: +6.6%
Da depth 3 a 4: +3.2%

I benefici maggiori si ottengono con 2-3 step intermedi; oltre depth 4, i miglioramenti diventano marginali e non statisticamente significativi.
Effetto del numero di linguaggi intermedi:

Da 0 a 1 linguaggio: +9.3% CA
Da 1 a 2: +12.9%
Da 2 a 3: +9.2%
Da 3 a 4: +5.6%
Da 4 a 5: +3.2%

Come per maxDepth, i benefici maggiori si ottengono con 2-3 linguaggi intermedi.
Quali linguaggi sono più importanti?
L'heatmap nel paper mostra che l'impatto varia per coppia:

Per C++→Java, rimuovere Rust causa -17.4% CA (statisticamente significativo)
Per Python→Java, rimuovere Rust causa -17.4% CA
Per Rust→Go, rimuovere C++ causa impatto significativo

Non esiste un "best pivot language" universale — dipende dalla coppia sorgente-target."

[CLOSING - Rilevanza per COBOL e Considerazioni Critiche]

"Rilevanza per la migrazione COBOL:
Il paper menziona esplicitamente il path COBOL→C→C++→Java come esempio. Questo è particolarmente interessante perché:

COBOL e C condividono il paradigma procedurale e la gestione esplicita della memoria
C e C++ sono sintatticamente vicini
C++ e Java condividono concetti OOP

INTERTRANS potrebbe essere applicato direttamente a migrazioni COBOL usando LLM multilingue, senza necessità di training specifico.
Punti di forza:

Nessun training richiesto — usa LLM off-the-shelf
Improvement significativo (+18-43% CA assoluto)
Approccio orthogonale a tecniche esistenti (può essere combinato con program repair, test generation)
Open source: codice disponibile su GitHub

Limitazioni:

Costo computazionale: anche con ottimizzazioni, esplorare l'albero è costoso (multiple inference calls per traduzione)
Dipendenza dalla test suite: richiede test per validare le traduzioni
Non spiega perché certi path funzionano: il paper identifica pattern ma non fornisce una teoria predittiva





















 


---
## 6. TOOL AUTOMATICI BASATI SU AI

### 6.1 Microsoft CAMF - COBOL Agentic Migration Factory 


[SLIDE 1 - Microsoft CAMF - Introduzione]
"CAMF — COBOL Agentic Migration Factory — è un framework open-source rilasciato da Microsoft nel luglio 2025, sviluppato in collaborazione con Bankdata, una technology company danese che serve un consorzio di otto banche rappresentanti oltre il 30% del mercato bancario danese.
Il contesto è significativo: Bankdata gestisce ancora oltre 70 milioni di righe di codice COBOL in produzione, eredità di sistemi che esistono dagli anni '60. Mentre la maggior parte del nuovo sviluppo è orientato verso cloud-native, alcuni workload mainframe non sono più un fit ottimale per quella piattaforma e beneficerebbero di un re-platforming.
I tre punti chiave che vedete:
1. Tre agenti AI — Non un singolo LLM monolitico, ma un'architettura multi-agente con specializzazione per task. Ogni agente ha una persona distinta ottimizzata per il suo compito specifico.
2. Prompt engineering (no training data) — Questo è cruciale: CAMF non richiede fine-tuning o dataset di training COBOL-Java. Usa LLM general-purpose (GPT-4.1, GPT-5 Mini) con prompt engineering sofisticato. Elimina i costi e la complessità di training task-specific, e permette di aggiornare immediatamente quando escono modelli migliori.
3. Collaborazione con Bankdata — Non è un toy project su codice COBOL sintetico. È stato testato su codice reale di produzione bancario, con tutte le complessità che questo comporta: commenti in danese, pattern legacy, dipendenze intricate.
Il framework è costruito su Microsoft Semantic Kernel con la Process Function per l'orchestrazione degli agenti. La scelta di Semantic Kernel rispetto ad AutoGen (usato nelle prime iterazioni) è dovuta alla sua maggiore maturità e alle capability di orchestrazione più robuste per scenari enterprise

[SLIDE 2 - Architettura]
"L'architettura che vedete nel diagramma segue un pattern di pipeline sequenziale con feedback loop. L'Orchestrator — implementato in MigrationProcess.cs — coordina i tre worker agents.
Agent 1: COBOLAnalyzerAgent
È il parsing engine fondamentale del sistema. La sua funzione è trasformare codice COBOL non strutturato in structured analysis data consumabile dagli altri agenti.
Cosa estrae concretamente:

Data Divisions con il loro scopo funzionale
Procedure Divisions e il flow logico
Variabili con level numbers, PIC clauses, group structures
Paragraphs e sections con call relationships interni
Embedded SQL/DB2 statements
File access patterns e FD linkage

I parametri di inferenza sono configurati per output deterministico:
csharpvar executionSettings = new OpenAIPromptExecutionSettings
{
    MaxTokens = 32768,    // Gestisce programmi legacy di grandi dimensioni
    Temperature = 0.1,    // Output quasi-deterministico
    TopP = 0.5            // Output focalizzato
};

Agent 2: DependencyMapperAgent
È il cervello architetturale del sistema. Analizza le relazioni tra programmi COBOL rilevando 8 tipi di statement con line numbers:

CALL — Invocazioni di programmi esterni
COPY — Inclusioni di copybook
PERFORM — Procedure calls e loop interni
EXEC SQL — Embedded SQL statements
READ — Operazioni di lettura file
WRITE — Operazioni di scrittura file
OPEN — Apertura file handles
CLOSE — Chiusura file handles

Ogni dipendenza viene tracciata con il line number esatto, permettendo audit e debug precisi. L'output alimenta sia il grafo nel portal che il contesto per il JavaConverterAgent.
Genera anche diagrammi Mermaid automaticamente — flowcharts che visualizzano le dipendenze con layout 'graph TB' o 'graph LR' basato sulla complessità del sistema.
Agent 3: JavaConverterAgent
Il transformation engine. Genera codice Java Quarkus production-ready dal COBOL analizzato. Ha guidelines specifiche per evitare 'JOBOL' — codice Java che replica direttamente la struttura COBOL invece di essere idiomatico:

Sostituire PERFORM con loop strutturati (for, while, do-while) o method calls
Eliminare GOTO ristrutturando la logica con if-else, switch-case, o metodi ben definiti
Applicare modern Java best practices con features Quarkus (dependency injection, reactive patterns)

Include retry logic con exponential backoff per gestire content filtering e timeouts di Azure OpenAI — essenziale per robustezza enterprise.
Hybrid Database Architecture (non mostrata nel diagramma):
CAMF usa un'architettura dual-database:

SQLite (Data/migration.db): metadata strutturati, contenuto file, analisi AI, codice generato
Neo4j (bolt://localhost:7687): grafi delle dipendenze, relazioni, visualizzazioni

Questa separazione ottimizza le query: SQLite risponde a "cosa c'è in questo file?", Neo4j risponde a "cosa dipende da questo file?" — due pattern di accesso fondamentalmente diversi."

[SLIDE 3 - Pipeline: Fase 1 e 2]
"La pipeline di CAMF è strutturata in tre fasi distinte. Le prime due — Preparation e Enrichment — sono spesso sottovalutate ma sono critiche per la qualità dell'output.
FASE 1: PREPARATION
L'obiettivo è preparare il codice COBOL per essere compreso dall'AI. Il team Microsoft ha scoperto empiricamente che la qualità del contesto in input è il fattore determinante per la qualità dell'output.
Reverse Engineering:
Non è solo parsing sintattico. Implica estrarre la business logic implicita da:

Il codice stesso (strutture, naming conventions)
Commenti esistenti (quando informativi)
Documentazione tecnica legacy
User handbooks e manuali operativi
SME umani — Subject Matter Experts che conoscono il sistema

Questo produce un glossary (Data/glossary.json) che mappa termini tecnici COBOL a concetti business, usato poi per arricchire il contesto degli agenti.
Code Cleaning:
Rimuovere informazioni che non aggiungono valore al contesto AI. Esempio tipico: i change logs negli header dei file COBOL — righe come:
cobol* 2003-05-12 JKS MODIFIED FOR Y2K COMPLIANCE
* 2005-08-23 MLR ADDED NEW FIELD WS-AMOUNT-2
```
Questi consumano token senza fornire informazione utile per la traduzione. Il cleaning libera context window per contenuto semanticamente rilevante.

**Translation:**
Nel caso Bankdata, il codice era in **danese** — una lingua di nicchia non presente in tutti i training set dei modelli. Tradurre commenti e nomi variabili in inglese migliora significativamente la comprensione del modello.

**FASE 2: ENRICHMENT**

L'obiettivo è arricchire il codice con contesto semantico che aiuti l'AI.

**Add Meaningful Comments:**
A volte l'opposto del cleaning è necessario. Commenti ben scritti — specialmente se **generati dall'AI stessa** in una fase precedente — aiutano a mantenere coerenza nelle fasi successive.

**Markdown ben-strutturato:**
Il team ha scoperto che contenuto in formato **markdown strutturato** — headers, bullet points, code blocks — è significativamente più efficace come contesto rispetto a testo non formattato. Questo è coerente con come i modelli sono stati trainati su documentazione tecnica.

**Identify Deterministic Structures:**
Pattern ricorrenti nel codice COBOL — come strutture di validazione input, gestione errori, logging — possono essere identificati e trattati in modo template-based invece che generativo, riducendo variabilità e errori.

**Document Temporary Results:**
Salvare le analisi intermedie permette di costruire contesto incrementalmente. Se l'Agent 1 produce un'analisi di alta qualità, questa viene persistita e riusata invece di essere rigenerata."

---

### **[SLIDE 4 - Pipeline: Fase 3 - Automation Aids]**

"La Fase 3 fornisce **artefatti e analisi** che supportano la migrazione umana oltre alla conversione automatica.

**Flow Analysis & Visualization:**

I **diagrammi Mermaid** generati automaticamente visualizzano:
- Call trees tra programmi
- Dipendenze copybook
- Circular dependencies (potenziali problemi architetturali)
- Critical files (nodi con alto in-degree o out-degree)

Questi non sono solo 'nice to have' — sono strumenti per gli **architetti umani** che devono validare e pianificare la migrazione.

Il DependencyMapperAgent usa due prompt specializzati:

*Prompt 1 - Mermaid Generation:*
```
Create a clear, well-organized Mermaid flowchart that shows COBOL program dependencies.
Use 'graph TB' or 'graph LR' based on complexity.
Group related items using subgraphs.
Use different colors for programs (.cbl) vs copybooks (.cpy).
```

*Prompt 2 - Architectural Analysis:*
```
Analyze the COBOL code structure and identify:
1. Data flow dependencies between copybooks
2. Potential circular dependencies
3. Modularity recommendations
4. Legacy patterns that affect dependencies
Test Generation:
Se esistono test file legacy, CAMF può costruire su di essi o sperimentare con un approccio TDD (Test-Driven Development) dove i test vengono generati prima della conversione e usati per validare l'output.
Questo è critico: senza strutture deterministiche di controllo (test), è impossibile validare la correttezza delle traduzioni.
Isolate Utility Functions:
Molto codice COBOL include logica che oggi gestiremmo via librerie standard: formatting di date, conversioni numeriche, string manipulation. Isolare e rimuovere questo codice early nella pipeline:

Riduce il volume di codice da tradurre
Riduce il consumo di token
Permette di usare librerie Java moderne invece di tradurre pattern obsoleti

Metriche reali dal caso Bankdata:
MetricaValoreFile COBOL processati102File Java generati99Success rate97%Chiamate API Azure OpenAI205Tempo totale~1.2 oreCosto totale$0.31
Questi numeri sono ordini di grandezza inferiori ai costi dei Global System Integrators tradizionali."

[SLIDE 5 - Portal COBOL Migration Insights]
"Quello che vedete è il portal web di CAMF, accessibile su localhost:5028. È un'interfaccia a tre pannelli:
Pannello sinistro - MCP Resources:

Accesso alle risorse via Model Context Protocol (MCP)
Example queries pre-configurate per analisi comuni
Shortcuts a documentazione e data guide

Pannello centrale - Chat Interface:

Interazione in linguaggio naturale con Azure OpenAI
Query sui dati di migrazione: "What are the circular dependencies?", "Which COBOL files have the highest impact?"
L'AI risponde interrogando sia SQLite (metadata) che Neo4j (grafi)

Pannello destro - Dependency Graph:

Visualizzazione interattiva delle dipendenze
Node Filters: Programs, Copybooks, Called Programs
Edge Filters: CALL, COPY, PERFORM, EXEC, READ, WRITE, OPEN, CLOSE — color-coded
Layout force-directed con zoom/pan

Multi-run support:
Il dropdown "Migration Run" permette di switchare tra run storici. Query come "Show me run 42" aggiornano automaticamente sia le risposte chat che il grafo.
Learnings tecnici dal team Microsoft:

Context overflow: Quando viene fornito troppo contesto, gli agenti perdono coerenza. Con contesto sufficientemente corto, la qualità era sorprendentemente alta.
Call-chain depth limit: La gestione delle call-chain — quale modulo chiama quale, a quale profondità — è risultata uno dei problemi più difficili. Il team ha raggiunto depth 3, ma non oltre.
Deterministic structures essenziali: Senza test, nessuna garanzia di correttezza."


[CLOSING - Rilevanza e Considerazioni]
"Punti di forza di CAMF per il nostro contesto:

Open source: Nessun vendor lock-in, agent prompts modificabili
No training required: Usa LLM off-the-shelf via prompt engineering
Costi trasparenti: $0.31 per 102 file vs costi GSI
Testato su codice reale: Bankdata, non toy examples
Architettura modulare: Possiamo usare solo il DependencyMapperAgent per analysis

Limitazioni:

Richiede Azure OpenAI (non OpenAI API standard out-of-box)
Call-chain depth ~3 può non bastare per sistemi molto accoppiati
Test suite esistente necessaria per validazione

Domande per il nostro team:

Abbiamo accesso ad Azure OpenAI?
Quale target: Java Quarkus o C# .NET?
Esistono test suite per i nostri sistemi COBOL?"

















### 6.2 Reforge-AI


[SLIDE 1 - REFORGE-AI - Introduzione]
"REFORGE-AI è un progetto sviluppato da Gian Paolo Santopaolo, pubblicato a maggio 2025, che dimostra un approccio agentico alla modernizzazione di codice legacy su larga scala.
Chiarimento importante per il nostro contesto:
REFORGE-AI è specifico per la migrazione Java Legacy → Spring Boot, non per COBOL. Tuttavia, lo includiamo in questa analisi perché il pattern architetturale — documentation-first con multi-agent orchestration — è direttamente applicabile anche alla modernizzazione COBOL. È un template metodologico più che un tool specifico.
I punti chiave:
Sistema agente AI basato su GPT-4:
Non usa un singolo prompt monolitico, ma un'architettura multi-crew costruita su CrewAI, un framework per orchestrazione di agenti AI. CrewAI permette di definire 'crew' di agenti specializzati che collaborano su task complessi.
Documentation-first approach:
L'insight fondamentale è generare documentazione autoritativa PRIMA di toccare il codice. Questo inverte l'approccio tradizionale dove la documentazione è un afterthought. La documentazione diventa il blueprint — letteralmente il prompt contestuale — per la fase di code generation.
Perché Spring Boot?
Il proof of concept usa il classico sample JBoss Kitchensink — un'applicazione Java EE di riferimento — ma l'obiettivo reale è la modernizzazione di sistemi bancari enterprise. Le banche tipicamente affrontano:

Code ownership silos: sviluppatori veterani con tribal knowledge che resistono al cambiamento
Documentazione sparsa o obsoleta: nuovi team costretti a reverse-engineering
Compliance bar elevata: traceability e security reviews obbligatorie

Questi sono esattamente i problemi che affrontiamo anche nella modernizzazione COBOL."

[SLIDE 2 - Fase 1 Documentation e Fase 2 Code Generation]
"L'architettura di REFORGE-AI si articola in due fasi distinte ma interconnesse.
FASE 1: DOCUMENTATION
La 'Documentation Crew' — un team di agenti AI — scansiona il codebase e il Javadoc esistente per inferire:

Module boundaries e responsabilità
Data flows tra componenti
Integration points con sistemi esterni

Output specifici:

Sequence e component diagrams in sintassi Mermaid
Dependency graphs delle librerie third-party
Service catalogs con endpoint signatures

Perché Mermaid? È una sintassi semplice ma potente per diagrammi che si integra direttamente in Markdown. I team possono impararla in un giorno e i diagrammi restano close to the code — aggiornabili insieme al codice stesso.
Human-in-the-Loop Refinement:
Questo è un punto critico che distingue REFORGE-AI da approcci fully-automated. Invece di fidarsi di un singolo pass LLM, implementa un improvement loop:

Gli ingegneri reviewano i docs auto-generati
Il feedback viene incorporato nei prompt degli agenti
Gli agenti ri-renderizzano diagrammi e testo aggiornati

Questo approccio ibrido è essenziale perché mitiga le hallucinations e garantisce allineamento con i requisiti di security e compliance. Alla fine della Fase 1, i team hanno un battle-tested migration plan con visualizzazioni Mermaid e step di upgrade precisi.
FASE 2: CODE GENERATION
La 'Gen Code Crew' configura agenti dedicati per task specifici:
Code Conversion Agent:

Trasforma EJB → Spring components (@Service, @Repository)
Converte Java EE patterns → Spring Boot idioms
Genera DTOs e mapping logic automaticamente

Dependency Update Agent:

Migra Java 8 → Java 21 (o Java 17 nel paper originale)
Aggiorna dependencies: Java EE → Spring Boot 3
Gestisce configurazioni plugin Maven

Test Scaffolding (implicito nel tuo Compliance Check Agent):

Genera JUnit 5 unit tests
Crea integration tests per i nuovi endpoints

Compliance Check Agent:

Verifica security annotations (@Secured, @PreAuthorize)
Applica style guides aziendali
Valida contro checklist compliance

Multi-Agent Choreography:
Questa separazione in agenti specializzati riflette un trend più ampio: gli AI agents come team members, non semplici autocomplete tools. Ogni agente ha una persona distinta ottimizzata per il suo task, e la documentazione generata in Fase 1 fornisce il contesto condiviso che permette agli agenti di lavorare coerentemente.
Gli agenti processano un modulo alla volta, producendo:

Clean Spring Boot services con annotazioni corrette
Build scripts aggiornati con plugin configurations moderne
DTOs auto-generati con mapping logic

Il codice 'just compiles' nella maggior parte dei casi, grazie allo scaffolding documentale e ai project skeletons forniti agli agenti."

[SLIDE 3 - Use Case e Limitazioni]
"Il use case presentato è Banking Legacy Java Migration — esattamente il contesto enterprise dove questi approcci hanno più valore.
Output generati:
ArtefattoDescrizioneArchitecture DocumentationDiagrammi Mermaid, module analysisMigration PlansStep-by-step upgrade pathModule AnalysisDependency graphs, integration pointsModernized CodeSpring Boot services, DTOs, configsTestsJUnit 5 unit e integration testsReportsCompliance checks, coverage reportsFeedback & SuggestionsRecommendations per improvement
Best Practices identificate:

Phased Incrementalism: Spezzare le migrazioni in slice logici (es. account services, transaction services). Questo riduce il rischio e si allinea con le strategie di de-risking bancarie.
Mermaid-First Documentation: Embedding diagrammi direttamente in Markdown garantisce che i docs restino vicini al codice e siano facili da aggiornare.
Agentic Orchestration: Usare agenti multipli specializzati invece di un prompt monolitico.
Human-in-the-Loop Guardrails: Review regolari catturano hallucinations e garantiscono allineamento con security e compliance.

LIMITAZIONI — Onestamente dichiarate:
1. Costi elevati (API GPT-4):
Questo è un fattore reale. GPT-4 API costs possono scalare rapidamente su codebase enterprise. Per un sistema con migliaia di file, i costi possono diventare significativi. Tuttavia, vanno comparati con i costi alternativi: mesi-uomo di sviluppatori senior.
2. Specializzato in Java Legacy:
REFORGE-AI è purpose-built per Java EE → Spring Boot. Non è generalizzabile out-of-the-box a COBOL o altri linguaggi. Per COBOL, servono tool come CAMF o XMainframe.
3. Built Agent Hallucinations:
Le hallucinations LLM sono un problema reale, specialmente in due aree identificate:
UI Generation:
Gli LLM eccellono nel backend refactoring ma falter su layout frontend intricati e CSS frameworks. Per progetti grandi, gli UI developers rimangono indispensabili per interfacce pixel-perfect.
pom.xml & Dependency Graphs:
Gli LLM general-purpose spesso mishandle le transitive dependencies Maven e le plugin versions, causando broken builds. Pipeline specializzate o tooling compiler-aware devono complementare gli LLM per stabilizzare i dependency trees.
Queste limitazioni evidenziano che, anche con AI agentica avanzata, l'expertise umana in UI/UX e build engineering rimane critica — è una partnership sinergistica human-AI, non una sostituzione."

[CLOSING - Rilevanza per il nostro contesto COBOL]
"Perché includiamo REFORGE-AI in una presentazione sulla migrazione COBOL?
Non perché sia applicabile direttamente — non lo è. Ma perché dimostra pattern architetturali che sono trasferibili:

Documentation-first approach: Generare documentazione autoritativa prima di toccare il codice funziona anche per COBOL. CAMF fa esattamente questo con la sua Fase 1 di Preparation.
Multi-agent specialization: Separare analysis, dependency mapping, e code conversion in agenti dedicati è un pattern che vediamo anche in CAMF (COBOLAnalyzerAgent, DependencyMapperAgent, JavaConverterAgent).
Human-in-the-loop refinement: Nessun sistema AI può operare fully-automated su migrazioni enterprise. Il feedback loop umano è essenziale.
Phased incrementalism: Processare un modulo alla volta, validare, procedere — funziona indipendentemente dal linguaggio source.

Confronto rapido:
AspettoREFORGE-AICAMFSource LanguageJava EECOBOLTargetSpring BootJava Quarkus / C# .NETFrameworkCrewAISemantic KernelLLMGPT-4Azure OpenAI (GPT-4.1/5)Documentation-first✅ Sì✅ SìMulti-agent✅ Sì✅ SìHuman-in-the-loop✅ Esplicito✅ ImplicitoOpen SourceSample project✅ GitHub
Takeaway:
REFORGE-AI è un reference implementation di come strutturare un sistema di modernizzazione AI-driven. I principi — documentation-first, multi-agent, human-in-the-loop — sono language-agnostic e applicabili anche al nostro contesto COBOL.

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
