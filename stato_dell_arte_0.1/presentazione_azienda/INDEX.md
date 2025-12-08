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

## 4. TRADUZIONE AUTOMATICA DEL CODICE CON LLM (6-7 min)

### 4.1 Traduzioni Transitive: InterTrans
**Contenuto della slide:**
InterTrans rivoluziona la traduzione automatica sfruttando le capacità multilingua degli LLM attraverso linguaggi intermedi. Invece della traduzione diretta (es. Python→Java), utilizza percorsi transitivi (Python→C++→Java) che colmano gap sintattici e semantici. Architettura: (1) Tree of Code Translation (ToCT) genera albero di percorsi candidati tra sorgente e target, (2) Validazione sequenziale via test suite. Risultati su CodeNet, HumanEval-X, TransCoder con Code Llama, Magicoder, StarCoder2: miglioramento assoluto 18.3%-43.3% in Computation Accuracy rispetto a traduzione diretta. Magicoder raggiunge 87.3%-95.4% CA media. La scelta del linguaggio intermedio è critica: C++→Java via Rust è particolarmente efficace. Costo computazionale elevato ma compensato da accuratezza superiore.

### 4.2 Migrazioni Incrementali Guidate dal Learning
**Contenuto della slide:**
MigrationExp applica learning-to-rank per guidare migrazioni incrementali Java→Kotlin su progetti Android. Analizza commit reali dove file Java vengono sostituiti da Kotlin, costruendo dataset dove ogni commit è una "query" e ogni file un "documento". Utilizza 56 feature (strutturali e Android-specific): ruolo delle classi (Activity, View, Service), complessità, accoppiamento, metriche di coerenza. LambdaMART impara pattern di migrazione degli sviluppatori e produce ranking di file da migrare per iterazione. Addestrato su 10.000+ esempi, ottiene MAP@K=0.225-0.308, superando selezione casuale e linee guida Google. Limita: dati solo da progetti open-source, approccio file-by-file, mancanza di "ordine ottimale" oggettivo.

---

## 5. LLM SPECIALIZZATI PER MAINFRAME (5 min)

### 5.1 XMainframe
**Contenuto della slide:**
XMainframe è un LLM state-of-the-art specializzato in sistemi mainframe e COBOL. Basato su DeepSeek-Coder 7B, disponibile in versioni 7B e 10.5B parametri. Include pipeline di raccolta dati dedicata: 236M token da progetti GitHub COBOL e documentazione mainframe. Introduce MainframeBench con 3 task: multiple-choice questions, question answering, COBOL summarization. Performance: +30% accuratezza vs DeepSeek-Coder su MCQ, doppio BLEU score vs Mixtral-Instruct 8x7B su Q&A, 6x superiore a GPT-3.5 su code summarization. Progettato per comprensione COBOL, documentazione assistita, supporto alla migrazione verso linguaggi moderni. Open-source su GitHub (FSoft-AI4Code/XMainframe).

### 5.2 Sistemi Agentici: CAMF di Microsoft
**Contenuto della slide:**
COBOL Agentic Migration Factory (CAMF) di Microsoft/Bankdata orchestra agenti AI specializzati via Semantic Kernel per migrazione automatica COBOL→Java/Quarkus. Architettura tri-fasica: (1) Preparazione: reverse engineering, pulizia codice, traduzione commenti, (2) Enrichment: aggiunta commenti significativi, identificazione strutture deterministiche, (3) Automation Aids: analisi flussi, generazione test, isolamento utility functions. Tre agenti coordinati: COBOLAnalyzerAgent (estrazione semantica, variabili, SQL/DB2, dipendenze copybook), DependencyMapperAgent (grafi architetturali Mermaid, identificazione pattern, metriche prioritizzazione), JavaConverterAgent (conversione production-ready con gestione PERFORM/GOTO, retry logic, parsing intelligente). Utilizza GPT-4.1 per reasoning. Repository open-source: Azure-Samples/Legacy-Modernization-Agents. Include IBM Watsonx Code Assistant for Z (20B parametri, 115 linguaggi, 1.5T token).

---

## 6. VALIDAZIONE E TESTING AUTOMATICO (4 min)

**Contenuto della slide:**
Framework IBM per validazione automatica trasformazioni COBOL→Java. Pipeline: (1) Symbolic execution genera input per paragrafi COBOL coprendo tutti i path logici (IF, EVALUATE, PERFORM), (2) Esecuzione COBOL su mainframe con mocking di risorse esterne (Db2, CICS, IMS, file), (3) Generazione automatica test JUnit equivalenti per Java, (4) Confronto output per verificare equivalenza funzionale. Già integrato in Watsonx Code Assistant for Z. Scalabile su enterprise codebase, raggiunge elevati branch coverage, riduce drasticamente tempo validazione vs approccio manuale. Ogni path rappresenta una traiettoria di esecuzione determinata dai rami logici: il framework assicura che tutte le varianti logiche siano validate, identificando errori nella traduzione Java.

---

## 7. RAPPRESENTAZIONI INTERMEDIE E METAMODELLI (5 min)

### 7.1 Evoluzione: Da AST a Data Flow Graph
**Contenuto della slide:**
GraphCodeBERT introduce data flow graph come alternativa efficiente agli AST nel pre-training. Il data flow codifica relazioni semantiche "da-dove-viene-il-valore" tra variabili: struttura più compatta, gerarchie meno profonde, maggiore efficienza computazionale rispetto agli AST tradizionali. StructCoder implementa encoder-decoder structure-aware che analizza sia AST che Data Flow Graph nell'encoder, e predice AST paths e data flow nel decoder. Questo obbliga il modello a "ragionare" sulla struttura durante la generazione.

### 7.2 Ottimizzazione Input: AST-Trans
**Contenuto della slide:**
AST-Trans affronta il problema dell'input length negli AST linearizzati (molto più lunghi del codice) e complessità O(N²) dell'attention standard. Soluzione: focus solo su relazioni critiche (ancestor-descendant per gerarchia, sibling per ordine operazioni) tramite matrici di relazione genitore-figlio e fratello-fratello. Risultati superiori vs AST standard in code summarization. Implicazione per migrazione: questi approcci possono essere integrati in architetture LLM custom per ottimizzare processamento di rappresentazioni strutturali del codice legacy.

---

## 8. APPROCCI MODULARI: Dynamic Language Product Lines (3 min)

**Contenuto della slide:**
Dynamic Language Product Lines (DLPL) applicano concetti di software product line ai linguaggi di programmazione. DLPL = insieme di varianti linguistiche ricombinabili dinamicamente a runtime. Micro-linguaggi = moduli che implementano funzionalità/domini specifici, sviluppabili e testabili indipendentemente. Esempio COBOL→Java: micro-linguaggio per calcolo interessi, micro-linguaggio per gestione conti, micro-linguaggio per reportistica moderna. Implementazione Neverlang: combina micro-linguaggi a runtime per supportare codice legacy e nuove estensioni simultaneamente. Vantaggio: migrazione graduale senza riscrittura completa, coesistenza legacy-moderno, testing incrementale. Non è un tool di conversione ma una metodologia architetturale per guidare modernizzazione modulare.

---

## 9. BENCHMARK E VALUTAZIONE (3 min)

**Contenuto della slide:**
CodeXGLUE (Microsoft Research 2021) resta benchmark fondamentale: 10 task diversificati, 14 dataset, 4 scenari (code-code, text-code, code-text, text-text), copertura di Java/Python/C#/PHP/JavaScript/Ruby/Go/C/C++. Task includono: clone detection (BigCloneBench 900K samples), defect detection (Devign), code completion (PY150, GitHub Java Corpus), code repair (Bugs2Fix), code translation Java↔C# (10K training), NL code search, text-to-code generation (CONCODE 100K), code summarization. Fornisce baseline BERT-style (CodeBERT), GPT-style (CodeGPT), Encoder-Decoder. Metriche standardizzate: BLEU, exact match, CodeBLEU per translation; accuracy per classification; MRR per retrieval. Standard de-facto per valutazione modelli pre-trained. Necessari nuovi benchmark per COBOL/mainframe specifici (vedi MainframeBench).

---

## 10. CONCLUSIONI E RACCOMANDAZIONI (3-4 min)

**Contenuto della slide:**
La migrazione di sistemi legacy è un problema complesso che richiede approcci multi-dimensionali. Non esiste soluzione universale: la scelta dipende da criticità sistema, budget, expertise disponibile, tolleranza al rischio. **Approccio raccomandato:** (1) Assessment approfondito con tool di analisi dinamica per capire cosa il sistema fa realmente, (2) Strategia incrementale (Strangler Fig) per ridurre rischi, (3) Scomposizione intelligente basata su analisi automatica per identificare boundary ottimali, (4) Utilizzo LLM specializzati (XMainframe, CAMF) per accelerare traduzione mantenendo qualità, (5) Testing automatico estensivo per garantire equivalenza funzionale, (6) Revisione umana sistematica su decisioni architetturali e codice mission-critical. Lo stato dell'arte offre strumenti potenti ma non sostituisce competenza di dominio: la modernizzazione è una partnership tra automazione AI ed expertise umana. Investimento in queste tecnologie può ridurre significativamente costi e tempi, ma richiede pianificazione attenta e commitment organizzativo.

---

## APPENDICE: Risorse e Repository