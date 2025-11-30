# Raccolta di articoli (link + riassunto)

## [Learning migration models for supporting incremental language migrations of software applications](https://pdf.sciencedirectassets.com/271539/1-s2.0-S0950584922X00104/1-s2.0-S0950584922001914/main.pdf?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEAYaCXVzLWVhc3QtMSJGMEQCIDwrDKE436OzRbjEVbQX9tRgtRuCd0ycQOfx8KcBBUzWAiAYyDK8GLf1l55qTUYUMRCapZNDMKq5gI1HY45Tsbt7xSq7BQjP%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F8BEAUaDDA1OTAwMzU0Njg2NSIM5PaEGUmRfcoebwSiKo8FVUzUNHpmXs0MZWlNKet6U29VLpVm7letRRN0MAsGeuIli5RP%2BSeEganuVg4hvZF97Vv9JYfcIJB6EhfL0bmbg7N1QNDiIsCokdR%2Bufiao5nfgG8LW1F3ZFY5B7P6KFa4vyLbZaGgc0efDIRnqHNJjiDeJE%2FPESaUOAEPBnQEQsVHYBFHSeJMiDo9IRiuaEGFKijjzR81NDohjbJM26irtzraAHVc2%2B6K0v%2F9cG%2FPARxC46YL%2ByK3cohy2nHfSoB28drl7P7jSkrvUxioDIvuDVsnRHZ%2BfPnLpKyAAa51coR7vLedlaHHLSbIjcmORC49n1JrtOlN2qgVxuwKNqKINmAV%2BM2jBse2QvnafTLK%2BWi23UiqE8JwfGWjHumT8v9B4ZUY4qjNj1pAe9UIqH3uJl9Ku3rpwRrJuQed02w%2B3HxQAus6CStqqxXgthdJoCovHqt0Zqo2ystFCn4jQ3N5WI27e9d5W3miexyHuyNdOIEMA2sPTT3yDTZPPtVsy%2Fs7AGlQdzZk%2FHWl6uQh8Z%2BG1O6JM77FCb7jp5qat4AqNk3XpEu1an7IzNvAw77tGnDTzA%2FxUXzCyJj4Szh%2FMvpPfU0QO6IwyKdq%2BUPHPQF96VJY8gGB%2FcsOeMewmk%2Bs05%2Fla9dmtoaVM83oWpKdvJXPzpnR%2BwkmzsDGeLGEqy5Sf0PIvfefsFnf%2FfKcVDF9059XXOrXola1beMDVs8gi9yv7QKoI9QSuulmjr4TCyIKhC%2Bq4B8aFHTNx2qOdoYGS4QPv5kpqMcozbtoUD3Vs6%2B8ovLl0p4NQz%2F8jKtUOZMcic1z1XsKaIGDL6ojsnEnfhOmMyF5Ht7kL6x7XaFLulOiw44ufYhDWBEeOAikCHucdjCF96vJBjqyAV8xb%2FLrPpo8yXCOY3mWuCYK4LudqW%2FozdCwq4NsW5yWYGWXSMtnzepiFLdWbK%2FyFuMBu9Esseze1pLFG%2FiVO7%2BlxVmI37G6KUux75gNpC8Xb1vHM5Xmp8D3i0Onn%2F%2FncYOKr0q2IQQc9C%2B2VQGhRhdcWH3tTZHytAPVmVBPrcyJw%2BNPt%2FdpEZpv5S%2F5JmLeXYV%2BynHPbELhdx8orSFCEFo3FiYSQvU%2F6alKaXVfrX%2FyVLE%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20251129T150621Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=ASIAQ3PHCVTYTOKN7RXE%2F20251129%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=ff0621cb77b883583ce9ba3ead18cf61c2d83b55452254f0e9d9a7c7b01d63bd&hash=66d4ca42c34bed9352b0c6d154b4c4f38113fc1dd1bb7b09983956ba64b32786&host=68042c943591013ac2b2430a89b270f6af2c76d8dfd086a07176afe7c76c2c61&pii=S0950584922001914&tid=spdf-327290c1-b1db-480c-a3e3-d012747aa929&sid=4225e19641b1694ef81826a-96da2ac89d99gxrqa&type=client&tsoh=d3d3LnNjaWVuY2VkaXJlY3QuY29t&rh=d3d3LnNjaWVuY2VkaXJlY3QuY29t&ua=131256045356505c550c03&rr=9a63022bca94ed47&cc=it)


MigrationExp è un approccio basato su *learning-to-rank* progettato per supportare gli sviluppatori nelle **migrazioni incrementali** del codice tra linguaggi, imparando direttamente dalle migrazioni reali osservabili nei repository open-source. L’idea centrale è analizzare commit in cui file Java vengono rimossi e sostituiti da corrispondenti file Kotlin, costruendo così un dataset in cui ogni commit diventa una “query” e ogni file del progetto un “documento” da ordinare secondo la probabilità di essere migrato. Attraverso 56 feature strutturali e Android-specifiche, il modello (LambdaMART) impara i pattern che guidano gli sviluppatori nella scelta dei file da migrare — come il ruolo delle classi (Activity, View, Service), la complessità, l’accoppiamento e altre proprietà del codice — e produce una classifica dei file da considerare in ogni passo della migrazione. L’implementazione concreta MigrationExpJ2K, applicata alla migrazione Java→Kotlin su progetti Android, è addestrata su oltre 10.000 esempi di migrazione e valutata con MAP@K (K=1..10), ottenendo valori compresi tra 0.225 e 0.308 e superando sia la selezione casuale sia una strategia derivata dalle linee guida di Google. I risultati indicano che il modello riesce a catturare in modo efficace il comportamento tipico degli sviluppatori durante la migrazione e può quindi fornire raccomandazioni utili per decidere l’ordine dei file da convertire; gli autori evidenziano tuttavia limiti legati alla natura dei dati open-source, al focus su migrazioni file-per-file e alla mancanza di una definizione oggettiva di “ordine ottimale” nella migrazione.

---

## How We Use AI Agents for COBOL Migration and Mainframe Modernization (https://devblogs.microsoft.com/all-things-azure/how-we-use-ai-agents-for-cobol-migration-and-mainframe-modernization/)

Il COBOL Agentic Migration Factory (CAMF) è un approccio sviluppato da Microsoft in collaborazione con Bankdata per automatizzare la modernizzazione di sistemi mainframe COBOL verso Java/Quarkus mediante agenti AI orchestrati con Microsoft Semantic Kernel. Il framework nasce dall'esigenza di migrare oltre 70 milioni di righe di codice mantenendo il controllo sulla proprietà intellettuale e riducendo i costi rispetto ai partner esterni.

![](500027838-c1faca51-dc21-41cf-9a51-70da5a3c8255.png)


![](camf_autogen-1024x651.png)

L'approccio si articola in tre fasi: Preparazione (reverse engineering, pulizia del codice, traduzione commenti), Enrichment (aggiunta commenti significativi, identificazione strutture deterministiche), e Automation Aids (analisi flussi, generazione test, isolamento funzioni utility). L'architettura implementa tre agenti specializzati coordinati da un controller:
Il COBOLAnalyzerAgent estrae semantica del codice mediante prompt AI (struttura programma, variabili, flussi procedurali, statement SQL/DB2, dipendenze copybook), configurato per analisi deterministica su programmi di grandi dimensioni. Il DependencyMapperAgent costruisce il grafo architetturale attraverso due prompt: il primo genera diagrammi Mermaid visualizzando dipendenze con subgraph dinamici; il secondo identifica pattern di data flow, dipendenze circolari e metriche quantitative (complessità, dipendenze medie) che guidano la prioritizzazione della migrazione. Il JavaConverterAgent trasforma il COBOL in Java Quarkus production-ready, gestendo costrutti specifici (PERFORM, GOTO) con cicli strutturati moderni invece di replicare la struttura originale ("JOBOL"), implementando retry logic, sanitizzazione contenuti e parsing intelligente.
Il flusso operativo segue una pipeline sequenziale: (1) scoperta file COBOL/copybook, (2) analisi struttura, (3) mapping dipendenze, (4) conversione a Java, (5) generazione report. L'uso di modelli reasoning come GPT-4.1 garantisce che il codice Java preservi accuratamente la logica business originale. Gli autori evidenziano però che non tutto il COBOL è ugualmente migrabile: moduli legati a comportamenti non funzionali del mainframe (throughput batch, I/O, orchestrazione JCL) richiedono spesso ripensamento architetturale oltre alla conversione. Il progetto è open-source su GitHub con prompt personalizzabili per casi d'uso specifici.

Link di riferimento:
Repository GitHub: https://github.com/Azure-Samples/Legacy-Modernization-Agents
Guida Argon Systems: https://argonsys.com/microsoft-cloud/library/how-we-use-ai-agents-for-cobol-migration-and-mainframe-modernization/


---
## [Code Reborn](https://arxiv.org/pdf/2504.11335) 
propone un'architettura ibrida per la migrazione COBOL→Java che combina parsing strutturale tramite ANTLR (per generare l'Abstract Syntax Tree) con un modello LSTM a 3 layer che suggerisce trasformazioni semantiche del codice. Il sistema include un'interfaccia React per visualizzare i miglioramenti attraverso dashboard, grafici e rappresentazioni AST interattive. L'approccio sfrutta il deep learning per catturare pattern complessi nella traduzione tra linguaggi. Nota critica: il repository GitHub non è disponibile (fare ricerche piu' approfondite sul codice). Il paper si presenta piu' come una sorta di questionario.

---
## [Reforge-AI](https://genmind.ch/posts/Using-Agentic-AI-To-Modernize-Large-Scale-Code/) 
è un sistema agente AI (basato su GPT-4) che modernizza automaticamente codebase Java legacy verso framework come Spring Boot, operando in due fasi: (1) **Analisi e Documentazione** tramite `gen_docs.py` che genera documentazione dettagliata e un piano `plan.yaml` soggetto a revisione umana, (2) **Trasformazione** tramite `gen_modern.py` che esegue refactoring automatizzato (conversione EJB→Spring Services, migrazione JSP→template moderni, aggiornamento dipendenze Maven, applicazione pattern OWASP, generazione test), richiedendo intervento umano per revisione del piano, validazione delle modifiche e verifica dei risultati. Il sistema utilizza un approccio multi-agente con loop di feedback iterativo dove ingegneri rivedono la documentazione auto-generata e gli agenti ri-renderizzano diagrammi Mermaid e testo aggiornati,
Per il feedback utilizzato nella sua archiettura, gli AI agents si interpretano come membri del team piuttosto che semplici strumenti di autocompletamento, rendendo l'approccio semi automatizzato.



-------------------------
## LLM  singoli presenti in letteratura
-------------------------
## [XMainframe: A LARGE LANGUAGE MODEL FOR MAINFRAME MODERNIZATION](https://arxiv.org/pdf/2408.04660)

LLM trainato su codice COBOL per la modernizzazione dei sistemi legacy.

[Github](https://github.com/FSoft-AI4Code/XMainframe)

## [GPT-MIGRATE](https://github.com/joshpxyne/gpt-migrate)

GPT-Migrate è un tool open-source che usa GPT-4 per migrare automaticamente un codebase da un linguaggio/framework a un altro

Aspetti negativi: 
1.Funziona bene solo su linguaggi semplici
2.Non e’ robusto come codice
3,In letteratura non ci sono grossi riferimenti sul suo utilizzo

-------------------------
## Analisi di aspetti tecnici sull'utilizzo di metamodelli
-------------------------

## [GraphCodeBERT - Pre-training Code Representations with Data Flow :utilizzo di GraphCode invece di AST)](https://openreview.net/pdf?id=jLoC4ez43PZ)

GraphCodeBERT usa data flow nella fase di pre-training, che è una struttura a livello semantico del codice che codifica la relazione "da-dove-viene-il-valore" tra variabili. Tale struttura a livello semantico è meno complessa e non porta una gerarchia inutilmente profonda di AST, proprietà che rende il modello più efficiente



## 
