# Raccolta di articoli (link + riassunto)

## [Learning migration models for supporting incremental language migrations of software applications](https://pdf.sciencedirectassets.com/271539/1-s2.0-S0950584922X00104/1-s2.0-S0950584922001914/main.pdf?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEAYaCXVzLWVhc3QtMSJGMEQCIDwrDKE436OzRbjEVbQX9tRgtRuCd0ycQOfx8KcBBUzWAiAYyDK8GLf1l55qTUYUMRCapZNDMKq5gI1HY45Tsbt7xSq7BQjP%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F8BEAUaDDA1OTAwMzU0Njg2NSIM5PaEGUmRfcoebwSiKo8FVUzUNHpmXs0MZWlNKet6U29VLpVm7letRRN0MAsGeuIli5RP%2BSeEganuVg4hvZF97Vv9JYfcIJB6EhfL0bmbg7N1QNDiIsCokdR%2Bufiao5nfgG8LW1F3ZFY5B7P6KFa4vyLbZaGgc0efDIRnqHNJjiDeJE%2FPESaUOAEPBnQEQsVHYBFHSeJMiDo9IRiuaEGFKijjzR81NDohjbJM26irtzraAHVc2%2B6K0v%2F9cG%2FPARxC46YL%2ByK3cohy2nHfSoB28drl7P7jSkrvUxioDIvuDVsnRHZ%2BfPnLpKyAAa51coR7vLedlaHHLSbIjcmORC49n1JrtOlN2qgVxuwKNqKINmAV%2BM2jBse2QvnafTLK%2BWi23UiqE8JwfGWjHumT8v9B4ZUY4qjNj1pAe9UIqH3uJl9Ku3rpwRrJuQed02w%2B3HxQAus6CStqqxXgthdJoCovHqt0Zqo2ystFCn4jQ3N5WI27e9d5W3miexyHuyNdOIEMA2sPTT3yDTZPPtVsy%2Fs7AGlQdzZk%2FHWl6uQh8Z%2BG1O6JM77FCb7jp5qat4AqNk3XpEu1an7IzNvAw77tGnDTzA%2FxUXzCyJj4Szh%2FMvpPfU0QO6IwyKdq%2BUPHPQF96VJY8gGB%2FcsOeMewmk%2Bs05%2Fla9dmtoaVM83oWpKdvJXPzpnR%2BwkmzsDGeLGEqy5Sf0PIvfefsFnf%2FfKcVDF9059XXOrXola1beMDVs8gi9yv7QKoI9QSuulmjr4TCyIKhC%2Bq4B8aFHTNx2qOdoYGS4QPv5kpqMcozbtoUD3Vs6%2B8ovLl0p4NQz%2F8jKtUOZMcic1z1XsKaIGDL6ojsnEnfhOmMyF5Ht7kL6x7XaFLulOiw44ufYhDWBEeOAikCHucdjCF96vJBjqyAV8xb%2FLrPpo8yXCOY3mWuCYK4LudqW%2FozdCwq4NsW5yWYGWXSMtnzepiFLdWbK%2FyFuMBu9Esseze1pLFG%2FiVO7%2BlxVmI37G6KUux75gNpC8Xb1vHM5Xmp8D3i0Onn%2F%2FncYOKr0q2IQQc9C%2B2VQGhRhdcWH3tTZHytAPVmVBPrcyJw%2BNPt%2FdpEZpv5S%2F5JmLeXYV%2BynHPbELhdx8orSFCEFo3FiYSQvU%2F6alKaXVfrX%2FyVLE%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20251129T150621Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=ASIAQ3PHCVTYTOKN7RXE%2F20251129%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=ff0621cb77b883583ce9ba3ead18cf61c2d83b55452254f0e9d9a7c7b01d63bd&hash=66d4ca42c34bed9352b0c6d154b4c4f38113fc1dd1bb7b09983956ba64b32786&host=68042c943591013ac2b2430a89b270f6af2c76d8dfd086a07176afe7c76c2c61&pii=S0950584922001914&tid=spdf-327290c1-b1db-480c-a3e3-d012747aa929&sid=4225e19641b1694ef81826a-96da2ac89d99gxrqa&type=client&tsoh=d3d3LnNjaWVuY2VkaXJlY3QuY29t&rh=d3d3LnNjaWVuY2VkaXJlY3QuY29t&ua=131256045356505c550c03&rr=9a63022bca94ed47&cc=it)

#### Q1

MigrationExp è un approccio basato su *learning-to-rank* progettato per supportare gli sviluppatori nelle **migrazioni incrementali** del codice tra linguaggi, imparando direttamente dalle migrazioni reali osservabili nei repository open-source. L’idea centrale è analizzare commit in cui file Java vengono rimossi e sostituiti da corrispondenti file Kotlin, costruendo così un dataset in cui ogni commit diventa una “query” e ogni file del progetto un “documento” da ordinare secondo la probabilità di essere migrato. Attraverso 56 feature strutturali e Android-specifiche, il modello (LambdaMART) impara i pattern che guidano gli sviluppatori nella scelta dei file da migrare — come il ruolo delle classi (Activity, View, Service), la complessità, l’accoppiamento e altre proprietà del codice — e produce una classifica dei file da considerare in ogni passo della migrazione. L’implementazione concreta MigrationExpJ2K, applicata alla migrazione Java→Kotlin su progetti Android, è addestrata su oltre 10.000 esempi di migrazione e valutata con MAP@K (K=1..10), ottenendo valori compresi tra 0.225 e 0.308 e superando sia la selezione casuale sia una strategia derivata dalle linee guida di Google. I risultati indicano che il modello riesce a catturare in modo efficace il comportamento tipico degli sviluppatori durante la migrazione e può quindi fornire raccomandazioni utili per decidere l’ordine dei file da convertire; gli autori evidenziano tuttavia limiti legati alla natura dei dati open-source, al focus su migrazioni file-per-file e alla mancanza di una definizione oggettiva di “ordine ottimale” nella migrazione.

---

## [INTERTRANS: Leveraging Transitive Intermediate Translations to Enhance LLM-based Code Translation](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=11029964&utm_source=scopus&getft_integrator=scopus&tag=1)

#### Conference Paper

Il paper “INTERTRANS: Leveraging Transitive Intermediate Translations to Enhance LLM-based Code Translation” affronta il problema della traduzione automatica di codice tra linguaggi di programmazione (PL). Gli autori propongono INTERTRANS, un metodo che utilizza traduzioni transitive attraverso linguaggi intermedi: costruiscono un “albero di traduzioni” (tramite l’algoritmo ToCT) per pianificare percorsi intermedi tra sorgente e target, generano le traduzioni con un modello LLM e verificano il risultato con test-suite. Su tre benchmark (CodeNet, HumanEval-X, TransCoder) e con vari LLM (Code Llama, Magicoder, StarCoder2), INTERTRANS migliora significativamente l’accuratezza computazionale delle traduzioni (miglioramenti assoluti in CA tra circa 18.3% e 43.3%, mediana ~28.6%). I risultati migliori riportano una CA media tra 87.3% e 95.4%. Gli autori concludono che la traduzione tramite linguaggi intermedi è una “strategia semplice ma efficace” per sfruttare le capacità multilingue degli LLM, migliorando in modo consistente la qualità della code translation rispetto alla traduzione diretta. L’approccio risulta particolarmente utile laddove sorgente e target sono molto distanti — a patto di avere test-suite per la verifica — e apre la strada a una tecnica sistematica per aumentare l’affidabilità delle traduzioni automatiche di codice.

---

## [Code Reborn](https://arxiv.org/pdf/2504.11335) 
propone un'architettura ibrida per la migrazione COBOL→Java che combina parsing strutturale tramite ANTLR (per generare l'Abstract Syntax Tree) con un modello LSTM a 3 layer che suggerisce trasformazioni semantiche del codice. Il sistema include un'interfaccia React per visualizzare i miglioramenti attraverso dashboard, grafici e rappresentazioni AST interattive. L'approccio sfrutta il deep learning per catturare pattern complessi nella traduzione tra linguaggi. Nota critica: il repository GitHub non è disponibile (fare ricerche piu' approfondite sul codice). Il paper si presenta piu' come una sorta di questionario.

---
## [Reforge-AI](https://genmind.ch/posts/Using-Agentic-AI-To-Modernize-Large-Scale-Code/) 
è un sistema agente AI (basato su GPT-4) che modernizza automaticamente codebase Java legacy verso framework come Spring Boot, operando in due fasi: 

(1) **Analisi e Documentazione** tramite `gen_docs.py` che genera documentazione dettagliata e un piano `plan.yaml` soggetto a revisione umana

(2) **Trasformazione** tramite `gen_modern.py` che esegue refactoring automatizzato (conversione EJB→Spring Services, migrazione JSP→template moderni, aggiornamento dipendenze Maven, applicazione pattern OWASP, generazione test), richiedendo intervento umano per revisione del piano, validazione delle modifiche e verifica dei risultati. Il sistema utilizza un approccio multi-agente con loop di feedback iterativo dove ingegneri rivedono la documentazione auto-generata e gli agenti ri-renderizzano diagrammi Mermaid e testo aggiornati.

Per il feedback utilizzato nella sua archiettura, gli AI agents si interpretano come membri del team piuttosto che strumenti di autocompletamento, rendendo l'approccio semi automatizzato.



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


## [StructCoder (Tipirneni et al., 2022)]()

introduce un modello Transformer encoder-decoder structure-aware per code generation (comprendere la struttura del codice sia quando lo legge (encoder) che quando lo genera (decoder).

l'Encoder analizza:

**AST (Abstract Syntax Tree)**: l'albero che rappresenta la struttura grammaticale del codice

**Data Flow Graph**: le relazioni tra le variabili (chi usa chi, chi dipende da chi) 

il decoder esegue due compiti aggiuntivi che lo obbligano a ragionare sulla struttura:

**AST Paths Prediction**: deve indovinare tutti i nodi dell'albero sintattico dal root alla foglia per ogni token

**Data Flow Prediction**: deve indovinare quali variabili dipendono da quali


Cosa ci dice questo paper? E' un paper vecchio che analizza la struttura di un LLM per la generazione ottimale di codice.Potrebbe aiutarci a modificare la struttura di un LLM open-source per la generazione di codice ottimale partendo da AST e Data Flow Graph.
Se seguiremo la strada degli LLM agent si dovra' capire tramite diverse tecniche, quale produce risultati migliori (invece di mettere il prompt testuale si da un AST o altri modelli)


---
## [AST-Trans (ICSE 2022)]()

Questo paper risolve un problema di code summarization.
Tuttavia non si tratta del nostro ambito di lavoro, ma puo' essere utile in futuro su come trattare gli input AST negli LLM.

I metodi attuali usano Transformer che prendono in input l'AST linearizzato.
Ci sono diversi problemi:

**Input molto lungo**: gli AST sono molto più lunghi del codice originale 

**Complessita' computazionale**: Il Transformer standard calcola l'attenzione tra tutti i nodi dell'AST, con complessità O(N²).

Gli autori osservano che non serve guardare tutti i nodi dell'AST bastano solo due tipi di relazioni:

**Ancestor-descendant** : per capire la struttura gerarchica del codice
**Sibling** : per capire l'ordine delle operazioni dentro uno stesso blocco

 AST-Trans funziona con l'utilizzo di matrici per calcolare le relazioni tra genitore-figlio e fratello-fratello.
 Da ottimi risultati invece del AST standard usato come input.

 
-------------------------
# Survey per la generazione di dati sintetici

Questo approccio puo' essere utilizzato nel caso di fine-tuning di modelli LLM.
Se si dovessere pensare alla soluzione come un agente AI, composto da vari LLM, queste tecniche ci risulterebbero utili per fine-tunare i vari LLM con dati sintetici.


---
## [Synthetic Data Generation Using Large Language Models: Advances in Text and Code](https://xplorestaging.ieee.org/ielx8/6287639/10820123/11080380.pdf?arnumber=11080380&utm_source=scopus&getft_integrator=scopus&tag=1&tag=1)

Questo paper è una survey completa che analizza come i Large Language Models vengono utilizzati per generare dati sintetici sia per task di linguaggio naturale che di programmazione. La survey copre tecniche, risultati empirici e sfide (come la qualità dei dati e il rischio di model collapse) .



Gli autori hanno seguito il seguente approccio per selezionare i paper:

**Criteri di inclusione:**
- Paper pubblicati tra gennaio 2020 e aprile 2025 (periodo boom degli LLM)
- Focus su synthetic data generation, data augmentation o instruction tuning con LLM
- Modelli con almeno centinaia di milioni di parametri (GPT-3/4, Claude, Llama, StarCoder, ecc.)
- Evidenza empirica o innovazione metodologica significativa

**Criteri di esclusione:**
- Lavori solo su immagini/audio senza metodologia trasferibile a testo/codice
- Contenuti non peer-reviewed senza rigore metodologico
- Paper pre-2020 su modelli pre-LLM (eccetto fondamentali)


| Tecnica utilizzata | Paper | Sintesi del lavoro |
|-------------------|-------|-------------------|
| **Prompt-Based Augmentation** | Li et al. [25] | Dimostrano miglioramenti del 3-26% in accuracy/F1 aggiungendo 100 esempi sintetici GPT-3.5 a 100 esempi reali in low-resource settings |
| **Retrieval-Augmented Generation** | Chai et al. [9] | Integrano retrieval di passaggi Wikipedia durante la generazione per groundare i dati sintetici e ridurre hallucination |
| **Topic-Controlled Prompting** | WANLI [32] | Variano sistematicamente il contenuto dei prompt per massimizzare diversità tra subtopic e migliorare generalizzazione |
| **Randomized Prompting** | AugGPT [35] | Usano prompting randomizzato per creare dataset sintetici con maggiore varietà |
| **Few-Shot Prompting** | GPT3Mix [31] | Applicano few-shot prompting per generare esempi task-specific con alta precisione di formato |
| **Instruction-Based Prompting** | Unnatural Instructions [34] | Generano dataset di istruzioni sintetiche per migliorare l'instruction-following dei modelli |
| **Iterative Generation** | Self-Instruct [29] | Metodo iterativo dove l'LLM genera nuove istruzioni partendo da seed prompts, creando dataset auto-generati |
| **Feedback-Driven Generation** | SunGen [30] | Focalizzano la generazione su failure cases e model weaknesses usando automated weighting |
| **Zero-Shot Topic Generation** | Yu et al. [24] | LLM genera prima lista di topic rilevanti, poi produce esempi specifici per ogni topic aumentando diversità |
| **Quality Filtering** | Ding et al. [3] | Analizzano se GPT-3 è un buon annotatore e sviluppano tecniche per filtrare output sintetici di bassa qualità |
| **Instruction-Following (Code)** | Code Alpaca [49] | Applicano Self-Instruct al dominio codice creando 20K esempi instruction-solution con ChatGPT |
| **Evolutionary Code Generation** | WizardCoder [51] | Usano strategia evolutiva (Code Evol-Instruct) per generare iterativamente task di coding sempre più complessi |
| **GitHub-Based Generation** | Magicoder [52] | Raccolgono snippet da GitHub e generano 75K instruction prompts che portano a quegli snippet come risposte |
| **Code Translation** | TransCoder - Lachaux et al. [8] | Usano LLM come GPT-4 per tradurre codice tra linguaggi diversi creando coppie parallele high-quality |
| **Code Refactoring** | Studio con CodeLLaMa-7B [44] | Pipeline di refactoring sistematico (rename, formatting, comments) che migliora performance fino al 30% |
| **Incremental Edit Generation** | LintSeq [42] | Generano sequenze di edit incrementali con CodeLLaMa-7B per insegnare ai modelli diversità nelle soluzioni |
| **Problem Solving** | AlphaCode - Microsoft [53] | Fine-tuning di CodeGen per generare candidati multipli a problemi di competitive programming |
| **RL-Based Algorithm Discovery** | AlphaDev - DeepMind [54] | Reinforcement learning con tecniche AlphaZero per scoprire algoritmi di sorting più efficienti |
| **Buggy Code Generation** | "LLM-itation" [56] | GPT-4 imita errori tipici di studenti creando buggy code realistico per sistemi di tutoring automatici |
| **Self-Improvement Code Repair** | Studio con GPT-3 [45] | Modello genera codice, identifica errori via unit tests, li ripara creando coppie (buggy, fixed) |
| **RL with Execution Feedback** | CodeRL [43] | Usa esecuzione corretta come reward signal per fine-tuning via reinforcement learning |
| **Standardized Generation Tools** | DataDreamer [64] | Framework per generazione standardizzata e riproducibile di dati sintetici con LLM |

---

## [From legacy to microservices: A type-based approach for microservices identification using machine learning and semantic analysis](https://www.scopus.com/pages/publications/85138198344?origin=resultslist)

Il paper propone MicroMiner, un approccio che combina analisi statica, analisi semantica e tecniche di machine learning per identificare microservizi a partire da applicazioni monolitiche. Il metodo classifica le classi del sistema in Application, Entity e Utility tramite un modello di ML; raggruppa poi le classi in servizi tipizzati utilizzando il clustering guidato dalle relazioni statiche; infine aggrega questi servizi in microservizi sfruttando un bilanciamento tra similarità semantica e dipendenze strutturali. L’approccio è validato su quattro sistemi legacy, mostrando prestazioni superiori a metodi state-of-the-art basati su metriche strutturali o topic modeling: MicroMiner raggiunge infatti una precisione del 68.15% (male) e un recall del 77% nell’individuazione dei microservizi, e genera componenti con maggiore coesione e minore accoppiamento. Le conclusioni evidenziano che MicroMiner automatizza efficacemente una delle fasi più complesse della migrazione verso architetture a microservizi, produce risultati architetturalmente significativi e migliora sia la qualità della decomposizione che la capacità di rispettare principi fondamentali come single responsibility e loose coupling, pur richiedendo ulteriore lavoro per gestire meglio classi mal nominate e casi con semantica poco chiara.

---