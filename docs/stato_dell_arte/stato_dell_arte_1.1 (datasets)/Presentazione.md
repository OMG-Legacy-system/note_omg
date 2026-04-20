Ecco una proposta di **presentazione in 4 slide**, focalizzata sugli articoli del Capitolo 3 (senza introduzione), già pronta da copiare in PowerPoint.

---

### **Slide 1 – COBREX: Estrazione delle Business Rules da COBOL**

**Ali et al.**

* Problema:

  * Le **regole di business** sono spesso **implicite nel codice COBOL** 
  * Difficili da comprendere e mantenere

* Soluzione: **COBREX**

  * Parsing del codice → costruzione **AST**
  * Generazione di **Control Flow Graph (CFG)**
  * Analisi delle variabili rilevanti

* Output:

  * Estrazione automatica delle **business rules**
  * Rappresentazione strutturata (grafi)

* Vantaggi:

  * Migliora comprensione del sistema
  * Supporta manutenzione e debugging 

---

### **Slide 2 – Ri-documentazione multi-linguaggio (COBOL → Java)**

**Dorninger et al.**

* Obiettivo:

  * Supportare la **migrazione da COBOL a Java**

* Approccio:

  * Analisi di **codice legacy + codice migrato**
  * Costruzione di rappresentazioni indipendenti dal linguaggio:

    * AST
    * Analisi di controllo e flusso dati

* Output:

  * **Diagrammi di flusso automatici**
  * Descrizione di:

    * Input/output
    * Accessi a file e database

* Benefici:

  * Migliore comprensione del sistema
  * Supporto a manutenzione ed evoluzione 

---

### **Slide 3 – Approcci AI per la comprensione del codice legacy**

**Balu & Bosco; Lei et al.**

* **AI-Native Modernization**

  * Framework basato su **agenti cooperanti**
  * Estrazione continua di:

    * Regole di business
    * Flussi dati
    * Dipendenze
  * Generazione:

    * Microservizi
    * Test e scaffolding
  * Presenza di **AI Co-Pilot** per supporto agli sviluppatori 

* **Multi-Agent LLM per spiegazioni COBOL**

  * Due agenti:

    * Code Processing Agent
    * Text Processing Agent
  * Pipeline gerarchica:

    * Funzione → file → progetto
  * Miglioramento significativo della qualità delle spiegazioni

* Impatto:

  * Automazione della documentazione
  * Facilitazione onboarding sviluppatori

---

### **Slide 4 – Reverse Engineering del Modello Dati**

**Ceccato et al.**

* Problema:

  * Modelli dati legacy **impliciti e non strutturati**
  * Uso di:

    * Overlay di memoria
    * REDEFINES / union-like

* Approccio:

  * Due pipeline:

    * Dati persistenti (dizionario → XMI)
    * Codice utente (trasformazioni TXL)
  * Estrazione di:

    * Tipi
    * Dimensioni
    * Relazioni tra variabili

* Tecniche:

  * Inferenza tramite **dimensioni e ridefinizioni**
  * Ricostruzione gerarchica delle strutture

* Output:

  * Traduzione in **modello object-oriented Java**

    * Classi annidate
    * Interfacce
    * Ereditarietà 

---

Se vuoi, posso anche:

* trasformarle direttamente in un file **.pptx scaricabile**
* oppure ridurle per esposizione orale (tipo 1 minuto per slide)
