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
Sono sistemi che assistono lo sviluppatore nelle decisioni durante la migrazione del codebase legacy.
Quelli che analizziamo sono due



Il primo, XMainframe, è un esempio di approccio basato su Deep Learning - utilizza un Large Language Model specializzato addestrato specificamente per la comprensione COBOL.

Il secondo, MigrationExp, rappresenta l'approccio Machine Learning classico - usa algoritmi di learning-to-rank per identificare l'ordine di file da migrare durante un processo di migrazione.

Forniscono supporto decisionale agli sviluppatori durante il processo di migrazione. Fanno parte del prccesso di analisi di pre-migrazione.


### 4.1 XMainframe
**[SLIDE 1 - Introduzione]**
XMainframe rappresenta il primo LLM open-source specificamente ottimizzato per la comprensione di sistemi mainframe e codebase COBOL. È stato sviluppato da FPT Software AI Center e pubblicato su arXiv ad agosto 2024
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


**[SLIDE 2 - GAP LLM esistenti]**
Prima di vedere come funziona XMainframe, chiediamoci: perché è stato necessario costruire un LLM specializzato? I CodeLLM esistenti — CodeLlama, StarCoder, Codex — non erano sufficienti?
Gli autori identificano tre gap fondamentali:
Gap 1: Training data insufficiente.
I CodeLLM general-purpose sono addestrati su un ampio spettro di linguaggi, ma la quantità di codice COBOL disponibile pubblicamente è insufficiente. E c'è un problema strutturale: le organizzazioni enterprise — banche, assicurazioni, enti governativi — mantengono le loro codebase mainframe private per requisiti di security e compliance. Quindi il dato semplicemente non esiste nei dataset di training pubblici.
Gap 2: Assenza di benchmark.
Prima di XMainframe, non esisteva un benchmark standardizzato per valutare quanto un LLM 'conosca' il mainframe. Come fai a sapere se il tuo modello è migliorato se non hai una metrica? Gli autori hanno dovuto creare MainframeBench proprio per colmare questa lacuna.
Gap 3: Comprensione oltre la generazione.
La modernizzazione mainframe non è generare codice COBOL — le organizzazioni vogliono migrare via da COBOL. Quindi il modello deve possedere una comprensione semantica profonda: capire cosa fa il codice, valutarne la complessità, identificare dipendenze. Questo va oltre le capability di code completion dei LLM standard.
Questi gap si traducono in un problema concreto: la code comprehension — capire il codice legacy prima di toccarlo — rappresenta il 40-60% dell'effort totale di un progetto di migrazione. È qui che XMainframe si posiziona.


**[SLIDE 3 - Architettura per la specializzazione del dominio]**

Vediamo ora come è stato costruito XMainframe per colmare questi gap.
Modello base: DeepSeek-CoderLa scelta di DeepSeek-Coder non è casuale. È un CodeLLM con architettura decoder-only, pre-trainato su un corpus di 87 linguaggi di programmazione. Un elemento chiave è la context window di 16K token ottenuta grazie a RoPE — Rotary Position Embedding.
Questo è fondamentale per COBOL: i programmi legacy enterprise possono essere molto lunghi, con file da migliaia di linee. Una context window ridotta significherebbe perdere informazioni critiche.
Pipeline di Training a due fasi:
Fase 1 - Continual Pre-Training:
Gli autori hanno costruito un dataset domain-specific da zero:
33,561 file COBOL raccolti da GitHub, filtrati per qualità e deduplicati con MinHash e Locality Sensitive Hashing — per un totale di 228 milioni di token
14,274 documenti di documentazione mainframe ufficiale — 8 milioni di token
Dati general-purpose da SlimOrca-Dedup per mantenere le capability di ragionamento e linguaggio naturale
Il totale è 236 milioni di token di dati domain-specific. Il Continual Pre-Training estende la conoscenza del modello base senza perdere le capability generali — un aspetto critico per evitare il catastrophic forgetting.
Fase 2 - Instruction Tuning:
Qui il modello impara a seguire istruzioni. Gli autori hanno creato Mainframe-Instruct, un dataset di 53,351 coppie istruzione-risposta generate tramite data augmentation con GPT-4-turbo come quality scorer.La differenza tra le due fasi è cruciale:

Il pre-training insegna al modello cosa sa — la conoscenza di COBOL
L'instruction tuning insegna al modello come rispondere — trasforma la conoscenza in output utili


MainframeBench — Il contributo scientifico:Prima di XMainframe non esisteva un modo standardizzato per valutare la conoscenza mainframe di un LLM. Gli autori hanno creato MainframeBench, il primo benchmark del settore, con tre task:
Multiple Choice Questions — 1,931 domande su sintassi COBOL, costrutti CICS/IMS, best practices
Question Answering — 2,598 domande aperte sulla semantica e architettura mainframe
COBOL Code Summarization — 2,523 task di spiegazione di codice COBOL
Questo benchmark è ora disponibile per la comunità e permette di confrontare oggettivamente qualsiasi LLM su task mainframe-specific."



**[SLIDE 4 - Benchmark]**
Vediamo i risultati su MainframeBench. Questi numeri dimostrano l'efficacia della specializzazione di dominio.

Multiple Choice Question Task:
Su questo task di classificazione, XMainframe-Instruct 10.5B raggiunge 77.89% di accuracy — superando GPT-4 che si ferma a 73.90%.
Ma il dato più significativo è il confronto con il modello base: DeepSeek-Coder-Instruct 6.7B, da cui XMainframe deriva, raggiunge solo 47.49%. Questo significa un miglioramento di +30 punti percentuali — ottenuto esclusivamente tramite domain adaptation, senza aumentare i parametri del modello.
Anche la versione 7B di XMainframe (68.57%) supera DeepSeek-Coder 33B (53.29%), che ha 5 volte più parametri. Questo dimostra che la specializzazione batte la scala quando si tratta di task domain-specific.

Question Answering Task:
Qui misuriamo la qualità delle risposte con metriche NLP standard: MAP, F1-Score, BERTScore, BLEU-4.
XMainframe-Instruct raggiunge un BLEU-4 di 20.93 — circa 5 volte superiore a GPT-4 (5.71) e DeepSeek-Coder (4.09-4.41). Il MAP di 0.43-0.45 contro 0.09-0.12 dei competitor conferma che XMainframe produce risposte più precise e contestualmente rilevanti.


COBOL Code Summarization:
Questo è il task più rilevante per il nostro contesto di migrazione — la capacità di spiegare cosa fa un pezzo di codice COBOL.
XMainframe-Instruct 10.5B raggiunge un BLEU-4 di 62.58 — questo è 8 volte superiore a GPT-4 (7.42) .
Guardate anche BERTScore: 0.96 per XMainframe contro 0.85 per GPT-4. Questo indica che le spiegazioni generate sono semanticamente molto più allineate con le reference rispetto ai modelli general-purpose.
Perché questi risultati?

La chiave è che i modelli general-purpose, pur essendo enormemente più grandi, non hanno visto abbastanza COBOL durante il training. XMainframe dimostra che un modello piccolo ma specializzato può superare modelli da centinaia di miliardi di parametri su task di nicchia. È un principio importante: per domini verticali come il mainframe, il domain adaptation è più efficace dello scaling bruto.

**[SLIDE 5 - Come funziona?]**

"Dal punto di vista dell'utente finale, come si usa concretamente XMainframe?
Input:
Il modello accetta codice COBOL — può essere un singolo paragrafo, una sezione, o un intero programma fino alla context window di 16K token.
Output — tre capability principali:

Spiegazione della complessità: Il modello analizza il codice e fornisce una valutazione della complessità strutturale — numero di branch, livelli di nesting, dipendenze esterne. Questo è fondamentale per la migration assessment: stimare l'effort prima di iniziare.

Spiegazione del codice COBOL: Genera summary in linguaggio naturale che descrivono cosa fa il codice. Come vedete nell'esempio — un paragrafo che gestisce formattazione di timestamp viene descritto in modo chiaro e conciso. Gli sviluppatori, anche quelli che non conoscono COBOL, possono capire la business logic.

Refactoring Suggestions: Il modello suggerisce miglioramenti al codice — pattern più moderni, eliminazione di ridondanze, preparazione per la migrazione. Questo supporta il processo di code cleaning prima della conversione.

Use Case nel ciclo di modernizzazione:
XMainframe si posiziona nella fase di code comprehension — quella che, ricordiamo, rappresenta il 40-60% dell'effort totale.

Comprensione del codice: Onboarding di nuovi sviluppatori su codebase legacy, documentazione automatica, knowledge transfer quando gli esperti COBOL vanno in pensione
Valutazione della migrazione: Assessment pre-migrazione, identificazione di moduli critici, stima della complessità di conversione



[SLIDE 6 - Modelli disponibili]
"XMainframe è rilasciato in tre varianti, ciascuna ottimizzata per use case diversi.
BASE-7B — Il modello grezzo:
Questo è il foundation model dopo il Continual Pre-Training, senza instruction tuning.
Quando usarlo:

Quando avete un dataset interno all'azienda con esempi specifici del vostro dominio
Quando volete adattare il modello ai pattern e alle convenzioni della vostra codebase COBOL specifica
Per creare versioni custom fine-tuned sulle vostre necessità

È la scelta giusta se avete un team ML interno e volete massimizzare la performance sul vostro specifico contesto enterprise.
INSTRUCT-7B — Il modello pronto all'uso:
Questo è il modello dopo instruction tuning — sa già rispondere a domande, generare summary, dare suggerimenti.
Quando usarlo:

Deployment immediato in IDE come assistente per sviluppatori
ChatBot interno per query sulla codebase
Generazione automatica di documentazione tecnica
Quando volete risultati out-of-the-box senza training aggiuntivo

È il punto di partenza raccomandato per la maggior parte delle organizzazioni.
INSTRUCT-10.5B — La versione potenziata:
Questa versione usa il depth up-scaling: il modello 7B viene espanso da 30 a 48 layer, raggiungendo 10.5 miliardi di parametri. Poi viene ri-trainato sul dataset mainframe.
Quando usarlo:

Quando avete capacità computazionale disponibile (GPU più potenti)
Per refactoring suggestions più accurati
Per analisi critica pre-migrazione su codice complesso
Quando l'accuracy è prioritaria rispetto alla latency

I benchmark mostrano che il 10.5B supera il 7B su tutti i task, con un salto significativo su COBOL summarization (62.58 vs 22.23 BLEU-4).








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
Passiamo ora ai tool automatici di migrazione basati su AI.
Cosa sono?
A differenza dei tool di supporto che abbiamo visto — che assistono lo sviluppatore nelle decisioni — questi sistemi eseguono la conversione del codice in modo automatico o semi-automatico.
A cosa servono?
Prendono codice legacy in input e producono codice modernizzato in output, gestendo l'intero processo di conversione: analisi delle dipendenze, generazione del codice target, creazione di documentazione e test.
Analizziamo due approcci:
CAMF (Microsoft) rappresenta l'approccio multi-agente specializzato — tre agenti AI coordinati che si occupano rispettivamente di analisi, dependency mapping e conversione. È progettato specificamente per COBOL → Java/C#.
REFORGE-AI rappresenta l'approccio documentation-first — genera prima documentazione completa del sistema legacy, poi usa quella documentazione come blueprint per la conversione automatica. È specifico per Java Legacy → Spring Boot, ma il pattern architetturale è applicabile anche ad altri contesti.
Entrambi si basano su architetture agentiche con LLM (GPT-4) e dimostrano come l'AI possa automatizzare fasi che tradizionalmente richiedevano settimane di lavoro manuale.
### 6.1 Microsoft CAMF - COBOL Agentic Migration Factory 


[SLIDE 1 - Microsoft CAMF - Introduzione]
"CAMF — COBOL Agentic Migration Factory — è un framework open-source rilasciato da Microsoft nel luglio 2025, sviluppato in collaborazione con Bankdata, una technology company danese che serve un consorzio di otto banche rappresentanti oltre il 30% del mercato bancario danese.
Il contesto è significativo: Bankdata gestisce ancora oltre 70 milioni di righe di codice COBOL in produzione, eredità di sistemi che esistono dagli anni '60. Mentre la maggior parte del nuovo sviluppo è orientato verso cloud-native, alcuni workload mainframe non sono più un fit ottimale per quella piattaforma e beneficerebbero di un re-platforming.
I tre punti chiave che vedete:
1. Tre agenti AI — Non un singolo LLM monolitico, ma un'architettura multi-agente con specializzazione per task. Ogni agente ha una persona distinta ottimizzata per il suo compito specifico.
2. Prompt engineering (no training data) — Questo è cruciale: CAMF non richiede fine-tuning o dataset di training COBOL-Java. Usa LLM general-purpose (GPT-4.1, GPT-5 Mini) con prompt engineering sofisticato. Elimina i costi e la complessità di training task-specific, e permette di aggiornare immediatamente quando escono modelli migliori.
3. Collaborazione con Bankdata — Non è un toy project su codice COBOL sintetico. È stato testato su codice reale di produzione bancario, con tutte le complessità che questo comporta: commenti in danese, pattern legacy, dipendenze intricate.


[SLIDE 2 - Architettura ed orchestrator]
CAMF è costruito su Semantic Kernel — il framework Microsoft per orchestrazione di agenti AI.
 L'orchestrator coordina i tre agenti in una pipeline sequenziale: ogni agente riceve l'output del precedente e alimenta il successivo.

LLM setting:
Temperature 0.1: Output quasi-deterministico. Per code translation vogliamo consistenza, non creatività — lo stesso input deve produrre lo stesso output per permettere testing e validazione.
TopP 0.5: Limita il sampling alle parole più probabili, riducendo variabilità.
MaxTokens 32768: Permette risposte lunghe — necessario perché la conversione di un programma COBOL complesso può generare centinaia di righe di Java.

Hybrid Database:
CAMF usa due database complementari perché servono a rispondere a domande diverse:
SQLite memorizza dati strutturati: contenuto dei file COBOL, analisi generate dagli agenti, codice Java prodotto, metadata dei run. È ottimizzato per query come 'dammi il contenuto del file X' o 'quali analisi abbiamo fatto?'
Neo4j memorizza il grafo delle dipendenze: quali programmi chiamano quali altri, quali copybook sono inclusi dove, con quale tipo di statement e a quale linea. È ottimizzato per query di grafo come 'se modifico questo copybook, quali programmi sono impattati?' o 'mostrami tutti i programmi a 2 livelli di distanza da questo entry point'.


**[SLIDE 3 - 3 agenti AI]**
"Vediamo ora i tre agenti specializzati che compongono il sistema. Ogni agente ha un ruolo preciso nella pipeline e passa il suo output al successivo.

Agent 1: COBOLAnalyzerAgent — Il Parsing Engine
È il primo agente della catena. Riceve codice COBOL grezzo — spesso mal documentato, con commenti in lingue diverse, pattern legacy degli anni '70 — e lo trasforma in structured analysis data.
Cosa estrae concretamente:

Data Division: variabili con level numbers, PIC clauses, group structures. Ad esempio, riconosce che WS-CUSTOMER-BALANCE PIC 9(7)V99 è un campo numerico con 2 decimali.
Procedure Division: il flow logico del programma, quali paragraphs esistono, come sono collegati
Embedded SQL/DB2: statement SQL incorporati nel COBOL, fondamentali per capire l'accesso ai dati
File access patterns: quali file vengono letti o scritti, con quale FD linkage



Agent 2: DependencyMapperAgent — Il Cervello Architetturale
Riceve l'analysis data e costruisce la mappa delle dipendenze tra programmi. Rileva 8 tipi di statement con il line number esatto:
Statement Cosa indica
CALL Invocazione di un programma esterno
COPY  Inclusione di un copybook
PERFORMChiamata a un paragrafo interno o estern
EXEC SQLStatement SQL embeddedREAD / WRITE Operazioni I/O su fileOPEN / CLOSE Gestione file handles
Ogni dipendenza include il numero di riga — ad esempio: Line 42: CALL 'FORMAT-BALANCE' USING WS-AMOUNT. Questo permette audit precisi e debug quando qualcosa non funziona.
L'output ha due forme:

Grafo Neo4j: per query programmatiche ('quali programmi sarebbero impattati se modifico questo copybook?')
Diagrammi Mermaid: per visualizzazione nel portal, generati automaticamente

Agent 3: JavaConverterAgent — Il Transformation Engine
È l'agente che effettua la conversione vera e propria. Riceve il contesto completo — analysis data + dependency map — e genera codice Java Quarkus production-ready.
Il punto critico è evitare quello che viene chiamato 'JOBOL' — codice Java che replica meccanicamente la struttura COBOL invece di essere idiomatico. Le guidelines specifiche includono:

PERFORM non diventa un metodo chiamato performParagraphX(), ma viene ristrutturato in loop idiomatici: for, while, do-while
GOTO — l'anti-pattern per eccellenza — viene eliminato e la logica ristrutturata con if-else, switch-case, o metodi ben definiti
Si applicano pattern moderni Quarkus: dependency injection, reactive patterns, annotazioni standard

L'agente include anche retry logic con exponential backoff per gestire i casi in cui Azure OpenAI ritorna errori di content filtering o timeout — in ambiente enterprise un singolo file può richiedere multiple chiamate API e deve essere robusto."



**[SLIDE 4 - Pipeline: Fase 1  2 3]**

La pipeline di CAMF si articola in tre fasi. È importante capire che queste fasi non sono solo tecniche — rappresentano una metodologia sviluppata dal team Microsoft-Bankdata basata su esperienza reale con 70 milioni di righe di COBOL.
Fase 1: PREPARATION — Preparare il codice per l'AI
Prima di dare codice COBOL a un LLM, bisogna prepararlo. Il codice legacy enterprise non è mai 'pulito':
Reverse Engineering: Estrarre la business logic non solo dal codice, ma da tutte le fonti disponibili — commenti, documentazione tecnica, user handbooks, e soprattutto SME umani (Subject Matter Experts). Spesso la vera logica di business non è documentata nel codice ma nella testa di chi ci lavora da 30 anni.
Code Cleaning: Rimuovere le informazioni che non aggiungono valore e che consumano context window inutilmente. Esempio tipico: gli header con change log — ogni modifica degli ultimi 40 anni tracciata in cima al file. Sono 200 righe di noise che confondono l'AI senza aggiungere valore semantico.
Translation: Nel caso di Bankdata, il codice ha commenti in danese. Gli LLM sono molto più performanti in inglese, quindi tradurre commenti e documentazione prima della conversione migliora significativamente la qualità dell'output.
Fase 2: ENRICHMENT — Arricchire con contesto semantico
Una volta pulito, il codice va arricchito per aiutare l'AI a capirlo meglio:
Add Meaningful Comments: Paradossalmente, aggiungere commenti prima di usare l'AI migliora i risultati. Commenti ben strutturati in markdown — specialmente se generati da AI in un primo pass — forniscono contesto che l'AI può sfruttare nel pass successivo. È un pattern di bootstrap: AI che aiuta AI.
Identify Deterministic Structures: Cercare pattern ricorrenti nel codice. Se 50 programmi hanno tutti la stessa struttura di error handling, documentare quel pattern permette all'AI di applicare una trasformazione consistente invece di reinventare la ruota ogni volta.
Document Temporary Results: Salvare le analisi intermedie. Se il COBOLAnalyzerAgent produce un'analisi particolarmente buona, salvarla e riusarla invece di rigenerarla. Questo costruisce contesto incrementale.
Fase 3: AUTOMATION AIDS — Supportare con artefatti
L'ultima fase genera artefatti che supportano sia l'AI che gli sviluppatori umani:
Flow Analysis & Visualization: Generazione automatica di diagrammi Mermaid e flowcharts. Questi visualizzano dipendenze e control flow in modo che gli sviluppatori possano verificare che l'AI abbia capito correttamente la struttura del sistema.
Test Generation: Generazione automatica di test cases. Idealmente in approccio TDD — generare i test prima della conversione, così da poter validare che il codice Java prodotto si comporti come l'originale COBOL. Senza test, non c'è garanzia di correttezza.
Isolate Utility Functions: Identificare funzioni che sono utility generiche — formattazione date, calcoli matematici, validazioni comuni. Queste non vanno tradotte 1:1 ma sostituite con librerie Java moderne equivalenti. Riduce il volume di codice da tradurre e migliora la qualità del risultato."

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
REFORGE-AI è un sistema agentico sviluppato da Gian Paolo Santopaolo nel 2025, progettato per modernizzare codebase Java legacy verso framework moderni come Spring Boot.
I tre punti chiave:
Sistema agente AI basato su GPT-4:
Non è un singolo prompt monolitico, ma un'architettura multi-agente dove diversi 'agenti' — ciascuno con un ruolo specifico — collaborano per completare task complessi. Importante chiarire: tutti gli agenti usano lo stesso modello GPT-4 sottostante, ma con prompt e persona diversi per ogni task.
Genera documentazione completa e piano di trasformazione:
Questo è l'approccio documentation-first — l'insight fondamentale è generare documentazione autoritativa prima di toccare il codice. La documentazione diventa poi il blueprint — letteralmente il prompt context — per la fase di code generation.
Specifico su Java Legacy → Spring Boot:
Il proof of concept usa il classico sample JBoss Kitchensink — un'applicazione Java EE di riferimento — ma l'obiettivo reale è la modernizzazione di sistemi bancari enterprise. È lo stesso contesto di CAMF, ma focalizzato su Java invece che COBOL.
Nota per il nostro contesto:
REFORGE-AI non è direttamente applicabile a COBOL, ma il pattern architetturale — documentation-first con multi-agent orchestration — è trasferibile. È un template metodologico."

[SLIDE 2 - Architettura ed Orchestrator]
"Vediamo l'infrastruttura che coordina il sistema.
CrewAI Framework:
REFORGE-AI è costruito su CrewAI — un framework Python per orchestrazione di agenti AI. A differenza di Semantic Kernel usato in CAMF, CrewAI è più leggero e orientato alla prototipazione rapida.
Il principio è semplice: ogni agente riceve l'output dell'agente precedente e produce un output che alimenta il successivo. È una pipeline sequenziale dove il lavoro viene passato da un agente all'altro.
Due Crew principali:
Il sistema è diviso in due pipeline separate:

Documentation Crew — eseguita da gen_docs.py — analizza il codebase e produce documentazione + piano di migrazione
Gen Code Crew — eseguita da gen_modern.py — esegue le trasformazioni effettive seguendo il piano

Feedback Loop Umano:
Questo è un punto critico che distingue REFORGE-AI da approcci fully-automated. Tra la Fase 1 e la Fase 2, un reviewer umano valida il piano di migrazione. Può modificarlo, aggiungere o rimuovere step, correggere errori di analisi.
Perché è importante? Perché se il piano è sbagliato, tutto il codice generato sarà sbagliato. Il checkpoint umano è una guardrail contro le hallucinations del modello."

[SLIDE 3 - Fase 1 Documentation Crew]
"La prima fase è gestita dalla Documentation Crew — un gruppo di agenti che scansiona il codebase legacy.
Processo:
Il workflow inizia con la scansione automatica del codice — nel caso del proof of concept, l'applicazione JBoss Kitchensink. Gli agenti analizzano:

La struttura del progetto
I pattern architetturali presenti (EJB, JPA, CDI)
Le dipendenze tra componenti

Poi eseguono un'analisi architetturale per capire come i moduli interagiscono tra loro, quali sono i punti di integrazione, dove sono le dipendenze critiche.
Viene quindi eseguita la generazione di diagrammi Mermaid — sequence diagrams, component diagrams — che visualizzano l'architettura in modo comprensibile. Mermaid è strategico perché i diagrammi si integrano direttamente in Markdown, quindi restano close to the code.
Infine, c'è il feedback umano — il reviewer valida l'analisi prima di procedere.
Output:
ArtefattoDescrizioneArchitecture DocumentationDiagrammi Mermaid, overview architetturaleModule AnalysisAnalisi per-modulo con responsabilitàDependency graphsMappa delle dipendenze tra componentiplan.yamlPiano strutturato con tutti gli step di migrazione
Il plan.yaml è l'output più importante: è il contratto tra Fase 1 e Fase 2, il documento che dice esattamente cosa deve essere trasformato e come."

[SLIDE 4 - Fase 2 Gen Code Crew]
"Con il piano validato, la Gen Code Crew esegue le trasformazioni effettive. Tre agenti specializzati lavorano in sequenza.
Code Generation Agent:
È l'agente che gestisce la conversione dei pattern architetturali:

EJB → Spring Components: trasforma Enterprise JavaBeans in annotazioni Spring — @Service, @Repository, @Controller
Java EE patterns → Spring Boot idioms: rimpiazza pattern legacy con equivalenti moderni — dependency injection, configuration classes, REST controllers

Usa la documentazione generata in Fase 1 come prompt context — questo è il cuore dell'approccio documentation-first. Il modello 'sa' cosa deve fare perché ha letto la documentazione.
Dependency Update Agent:
Gestisce l'aggiornamento tecnologico:

Java 8 → Java 21: migrazione della versione del linguaggio, adattamento di API deprecate
Java EE patterns → Spring Boot 3: aggiornamento delle dipendenze nel pom.xml, risoluzione di conflitti
Genera Unit Tests con JUnit 5: crea test automatici per validare che le trasformazioni siano corrette

La generazione di test è cruciale: senza test, non c'è modo di verificare che il codice migrato si comporti come l'originale.
Compliance Check Agent:
È l'agente di quality assurance:

Verifica Security Annotations: controlla che @Secured, @PreAuthorize siano applicati correttamente
Applica Style Guides: garantisce che il codice segua le convenzioni aziendali
OWASP best practices: incorpora pattern di secure coding per prevenire vulnerabilità comuni

Questa separazione in agenti specializzati riflette il principio che task diversi richiedono competenze diverse — anche se sotto il cofano è sempre lo stesso modello GPT-4 con prompt differenti."

[SLIDE 5 - Punti di forza e Limitazioni]
"Chiudiamo con una valutazione onesta di REFORGE-AI.
Punti di forza:
Non è richiesto training:
Come CAMF, REFORGE-AI usa prompt engineering su modelli general-purpose. Non servono dataset COBOL-Java, non serve fine-tuning. Si può iniziare subito e si può aggiornare immediatamente quando escono modelli migliori.
Human-in-the-loop validation:
Il checkpoint umano tra le due fasi riduce il rischio di errori catastrofici. Le decisioni critiche sono validate da esperti di dominio prima di essere applicate.
Testato su codice reale:
Non è un toy project su codice sintetico. È stato testato su JBoss Kitchensink, un'applicazione Java EE reale con tutte le complessità che questo comporta.
Limitazioni — Onestamente dichiarate dall'autore stesso:
Costi elevati (API GPT-4):
GPT-4 è costoso. Per codebase enterprise con migliaia di file, i costi API possono scalare rapidamente. Confrontate con CAMF che dichiara $0.31 per 102 file — REFORGE-AI non fornisce benchmark di costo, ma essendo basato su GPT-4 sarà comparabile o superiore.
Specializzato Java Legacy:
Non è generalizzabile out-of-the-box. Per COBOL serve un sistema come CAMF. Il pattern architetturale è trasferibile, ma il codice no.
Build Agent Hallucinations:
L'autore stesso documenta che i log di build simulati possono essere inaccurati. Quando un agente deve 'fingere' output deterministici come log di compilazione, gli LLM tendono a inventare — è un problema noto.
Inconsistent Model Outputs:
Eseguire gen_docs.py più volte può produrre risultati diversi. Questo è aggravato dal fatto che tutti gli agenti usano lo stesso modello GPT-4 — non c'è diversificazione. Se il modello ha un 'bad day' o degrada sotto uso intensivo, tutti gli agenti ne risentono contemporaneamente. È un single point of failure architetturale.
Takeaway:
REFORGE-AI è un proof of concept che dimostra il pattern documentation-first con multi-agent orchestration. Non è production-ready come CAMF, ma i principi sono solidi e applicabili anche al nostro contesto COBOL."
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
