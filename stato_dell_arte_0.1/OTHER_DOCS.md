
## [How We Use AI Agents for COBOL Migration and Mainframe Modernization](https://devblogs.microsoft.com/all-things-azure/how-we-use-ai-agents-for-cobol-migration-and-mainframe-modernization/)

Il COBOL Agentic Migration Factory (CAMF) è un approccio sviluppato da Microsoft in collaborazione con Bankdata per automatizzare la modernizzazione di sistemi mainframe COBOL verso Java/Quarkus mediante agenti AI orchestrati con Microsoft Semantic Kernel. Il framework nasce dall'esigenza di migrare oltre 70 milioni di righe di codice mantenendo il controllo sulla proprietà intellettuale e riducendo i costi rispetto ai partner esterni.

![](./figures/500027838-c1faca51-dc21-41cf-9a51-70da5a3c8255.png)


![](./figures/camf_autogen-1024x651.png)

L'approccio si articola in tre fasi: Preparazione (reverse engineering, pulizia del codice, traduzione commenti), Enrichment (aggiunta commenti significativi, identificazione strutture deterministiche), e Automation Aids (analisi flussi, generazione test, isolamento funzioni utility). L'architettura implementa tre agenti specializzati coordinati da un controller:
Il COBOLAnalyzerAgent estrae semantica del codice mediante prompt AI (struttura programma, variabili, flussi procedurali, statement SQL/DB2, dipendenze copybook), configurato per analisi deterministica su programmi di grandi dimensioni. Il DependencyMapperAgent costruisce il grafo architetturale attraverso due prompt: il primo genera diagrammi Mermaid visualizzando dipendenze con subgraph dinamici; il secondo identifica pattern di data flow, dipendenze circolari e metriche quantitative (complessità, dipendenze medie) che guidano la prioritizzazione della migrazione. Il JavaConverterAgent trasforma il COBOL in Java Quarkus production-ready, gestendo costrutti specifici (PERFORM, GOTO) con cicli strutturati moderni invece di replicare la struttura originale ("JOBOL"), implementando retry logic, sanitizzazione contenuti e parsing intelligente.
Il flusso operativo segue una pipeline sequenziale: (1) scoperta file COBOL/copybook, (2) analisi struttura, (3) mapping dipendenze, (4) conversione a Java, (5) generazione report. L'uso di modelli reasoning come GPT-4.1 garantisce che il codice Java preservi accuratamente la logica business originale. Gli autori evidenziano però che non tutto il COBOL è ugualmente migrabile: moduli legati a comportamenti non funzionali del mainframe (throughput batch, I/O, orchestrazione JCL) richiedono spesso ripensamento architetturale oltre alla conversione. Il progetto è open-source su GitHub con prompt personalizzabili per casi d'uso specifici.

Repository GitHub: https://github.com/Azure-Samples/Legacy-Modernization-Agents

Guida Argon Systems: https://argonsys.com/microsoft-cloud/library/how-we-use-ai-agents-for-cobol-migration-and-mainframe-modernization/


---

## [Automated Testing of COBOL to Java Transformation](https://www.scopus.com/pages/publications/105013962212?origin=resultslist)

L’articolo presenta un framework IBM per validare automaticamente la trasformazione da COBOL a Java eseguita da modelli LLM. Il sistema genera input tramite symbolic execution dei paragrafi COBOL, esegue il codice COBOL sul mainframe con mocking delle risorse esterne (come Db2, CICS, IMS e file), costruisce test JUnit equivalenti per il Java generato e confronta gli output per verificare l’equivalenza funzionale. I risultati dimostrano che la soluzione è scalabile su codice enterprise molto ampio, raggiunge elevati livelli di branch coverage e riduce significativamente il tempo necessario rispetto alla validazione manuale. Il framework individua eventuali errori nella traduzione Java e fa già parte del prodotto Watsonx Code Assistant for Z.

I *path* citati nell’articolo rappresentano le diverse traiettorie di esecuzione possibili all’interno di un paragrafo COBOL, determinate dai rami logici creati da istruzioni come IF, EVALUATE o PERFORM. Ogni path corrisponde a una sequenza specifica di istruzioni attraversate in base a determinati valori di input. Il framework genera automaticamente questi path tramite symbolic execution e li utilizza per confrontare gli output COBOL e Java, assicurando che tutte le varianti logiche del codice originale siano correttamente validate.


---

## [Cross-Language Code Mapping with Transformer Encoder-Decoder Model](https://www.scopus.com/pages/publications/85208057324?origin=resultslist)

Problemi di accesso

---

## [Modernizing 90S ERA Software to a New Language and Environment Using LLMS - An Empirical Investigation](https://www.researchgate.net/publication/391612744_Modernizing_90S_ERA_Software_to_a_New_Language_and_Environment_Using_LLMS_-_An_Empirical_Investigation)

Articolo richiesto, in attesa

---

# Benchmark 



---

## [CodeXGLUE: A Machine Learning Benchmark Dataset for Code Understanding and Generation (Lu et al., 2021)](https://www.alphaxiv.org/abs/2102.04664v2)


 è un benchmark completo introdotto da Microsoft Research per task di comprensione e generazione di codice.

 Il benchmark aggrega 10 task diversificati su 14 dataset che coprono quattro scenari principali: 

 **code-code** (clone detection su BigCloneBench con 900K/416K/416K samples e POJ-104, defect detection su Devign, cloze test CT-all/CT-max/min su 6 linguaggi, code completion su PY150 e GitHub Java Corpus, code repair su Bugs2Fix, code translation Java↔C# su 10K training samples)

 **text-code** (natural language code search, text-to-code generation su CONCODE con 100K samples), 
 
 **code-text** (code summarization)
 
**text-text** (documentation translation su 5 lingue naturali). 

Il benchmark fornisce tre sistemi baseline pronti all'uso: BERT-style (CodeBERT) per task di understanding, GPT-style (CodeGPT/CodeGPT-adapted) per completion e generation, ed Encoder-Decoder per sequence-to-sequence generation. 

CodeXGLUE ha metriche standardizzate per task (BLEU, exact match, CodeBLEU per translation; accuracy per classification; MRR per retrieval). 

Il benchmark supporta multiple programming languages (Java, Python, C#, PHP, JavaScript, Ruby, Go, C/C++) e rappresenta il primo benchmark diversificato che può essere applicato a vari problemi di code intelligence, diventando lo standard de-facto per valutazione di modelli pre-trained per codice.

---


## [From Monolith to Microservice: Measuring Architecture Maintainability](https://www.scopus.com/pages/publications/85161180737?origin=resultslist)

---