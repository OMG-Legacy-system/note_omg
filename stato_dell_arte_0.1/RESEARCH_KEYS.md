Research query per Sistemi di migrazione di Legacy system
```
TITLE-ABS-KEY ( ( "Legacy"  OR  "Legacy System" )  AND  ( "Migration"  OR  "Obsolete"  OR  "Modernization" )  AND  ( "code"  OR  "language"  OR  "program" ) )  AND  PUBYEAR  >  2019  AND  PUBYEAR  <  2026  AND  ( LIMIT-TO ( SUBJAREA ,  "COMP" )  OR  LIMIT-TO ( SUBJAREA ,  "ENGI" )  OR  LIMIT-TO ( SUBJAREA ,  "MULT" )  OR  LIMIT-TO ( SUBJAREA ,  "ECON" )  OR  LIMIT-TO ( SUBJAREA ,  "BUSI" ) )  AND  ( LIMIT-TO ( DOCTYPE ,  "ar" )  OR  LIMIT-TO ( DOCTYPE ,  "re" ) ) 
```
Da restringere a 2022-2023 per sistemi llm-based

Research query per Sistemi di migrazione di Legacy system - AI BASED
```
TITLE-ABS-KEY ( ( "Legacy" OR "Legacy System" ) AND ( "llm" OR "AI" OR "artificial intelligence" ) AND ( "Migration" OR "Obsolete" OR "Modernization" ) AND ( "code" OR "language" OR "program" ) ) AND PUBYEAR > 2022 AND PUBYEAR < 2026 AND ( LIMIT-TO ( SUBJAREA , "COMP" ) OR LIMIT-TO ( SUBJAREA , "ENGI" ) OR LIMIT-TO ( SUBJAREA , "MULT" ) OR LIMIT-TO ( SUBJAREA , "ECON" ) OR LIMIT-TO ( SUBJAREA , "BUSI" ) ) AND ( LIMIT-TO ( DOCTYPE , "ar" ) OR LIMIT-TO ( DOCTYPE , "re" ) ) 
```
Salgo da 7 a 11 articoli aggiungendo machine learning

```
TITLE-ABS-KEY ( ( "Legacy" OR "Legacy System" ) AND ( "llm" OR "AI" OR "artificial intelligence" OR “machine learning” ) AND ( "Migration" OR "Obsolete" OR "Modernization" ) AND ( "code" OR "language" OR "program" ) ) AND PUBYEAR > 2022 AND PUBYEAR < 2026 AND ( LIMIT-TO ( SUBJAREA , "COMP" ) OR LIMIT-TO ( SUBJAREA , "ENGI" ) OR LIMIT-TO ( SUBJAREA , "MULT" ) OR LIMIT-TO ( SUBJAREA , "ECON" ) OR LIMIT-TO ( SUBJAREA , "BUSI" ) ) AND ( LIMIT-TO ( DOCTYPE , "ar" ) OR LIMIT-TO ( DOCTYPE , "re" ) ) 
```

Se l'approccio deve essere ai based, probabilmente il sistema deve passare per diverse fasi. 
Assumendo che il codice sia di buona qualità (assunzione non da dare per scontato) e ben documentato, bisognerebbe capire l'ordine migliore di conversione (vedere paper in *AI_RESEARCH_BIB*).

Successivamente andrebbe implementato un sistema che includa la documentazione esistente con della documentazione generata (che in questo caso rappresenta una prior)

Nella documentazione generata bisogna considerare
- disomogeneità del parco applicativo e sistemi proprietari
- definizione del processo di migrazione e delle caratteristiche (ad es. mission critical o non mission critical)
- definizione del dominio (amichevoli, trattabili, ostili, studio della decomponibilità)

Considerando la natura del codice generato andrebbero eseguiti test su ogni pezzo di codice generato con sistemi di probing (con performance test)

Inoltre potrebbe essere utile utilizzare un linguaggio intermedio nella conversione. In questo modo dato un codice x andrebbe tradotto nel linguaggio intermedio prima di passare al linguaggio finale _(IR, AST, pseudocode, NL intermedio, ecc.)_.


```
( "large language model" OR LLM OR "language model" OR "deep learning" OR "neural" OR "machine learning" ) AND ( "code translation" OR "source-to-source" OR transpil* OR transcompil* OR "program translation" OR "code migration" OR "program migration" OR "program transpiler" ) AND ( "intermediate representation" OR IR OR "intermediate code" OR AST OR "abstract syntax tree" OR pseudocode OR "pseudo-code" OR "natural language" OR "NL" )
```

o, per comparativo

```
( "large language model" OR LLM OR "language model" OR "deep learning" OR "neural" OR "machine learning" ) AND ( "code translation" OR "source-to-source" OR transpil* OR transcompil* OR "program translation" OR "code migration" OR "program migration" OR "program transpiler" ) AND ( "intermediate representation" OR IR OR "intermediate code" OR AST OR "abstract syntax tree" OR pseudocode OR "pseudo-code" OR "natural language" OR "NL" ) AND ( compar* OR "vs" OR "versus" OR "compare" OR "comparison" OR "direct translation" OR "pipeline" OR "two-stage" OR "intermediate" )

```


Nel processo di traduzione andrebbe considerata la presenza di librerie non native del linguaggio. Questo potrebbe avvenire in diversi modi, anche se l'intervento umano è consigliato