# Raccolta di articoli (link + riassunto)

## [A tool assisted Agile approach for legacy application migration - 2025](https://link.springer.com/content/pdf/10.1007/s13198-025-02823-3.pdf?utm_source=scopus&getft_integrator=scopus)

L’articolo presenta un approccio Agile supportato da una suite di strumenti progettata per la migrazione di applicazioni legacy. La suite integra analisi dinamica del comportamento a runtime, generazione automatica di dati di test, individuazione delle funzionalità realmente utilizzate e trasformazione di tali evidenze in storie Agile utili alla pianificazione della migrazione. Il nucleo tecnico è un framework open-source di dynamic instrumentation, che consente di osservare l’esecuzione reale del software legacy e ricavarne complessità, frequenza d’uso e dipendenze funzionali. A questo si affiancano strumenti personalizzati per l’analisi, la generazione di test e la validazione dei componenti migrati, supportati da un augmented real-execution framework che permette la coesistenza del sistema legacy con quello nuovo durante la transizione. L’intera suite si integra con IDE diffusi e copre tutte le fasi della migrazione: analisi, scomposizione funzionale, sviluppo, test e verifica finale.

| Strumento / componente | Descrizione e ruolo |
|------------------------|---------------------|
| Framework di dynamic instrumentation (open-source) | Raccoglie trace di esecuzione, invocazioni di funzioni, complessità e comportamento runtime del sistema legacy. |
| Tool di analisi dinamica (custom) | Elabora i dati runtime per identificare funzioni utilizzate, codice morto, complessità e frequenza di uso. |
| Tool di generazione di test data (custom) | Crea dati di test per validare i componenti migrati secondo principi di test-driven development. |
| Componente di conversione trace → storie Agile | Trasforma il comportamento osservato in storie del backlog con stime derivate dalla complessità reale. |
| Augmented real-execution framework | Consente la coesistenza e il confronto tra componenti legacy e componenti migrati per una validazione continua. |
| Integrazione con IDE diffusi | Supporta sviluppo, refactoring e test dei componenti migrati all’interno degli ambienti di sviluppo più usati. |


## [Software modernization powered by dynamic language product lines](https://pdf.sciencedirectassets.com/271629/1-s2.0-S0164121224X00096/1-s2.0-S0164121224002322/main.pdf?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEAcaCXVzLWVhc3QtMSJIMEYCIQCD54w%2FJhlqzSUtw%2BhdKDDMeIuGsg3aa1uoQ7K%2F2Sn7hgIhAKI43mkvPw4z5Beu8WKwNzXd5m6XEjjC6A93e%2Bt76qZqKrsFCM%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQBRoMMDU5MDAzNTQ2ODY1IgzAsTfAvRshCII7gbAqjwWE6HxAivKMYntCL3kqecgwKM2kBcL2LtPYTMRuCfz1TfDt5ANN3x1WmVgEsWG3GIWNfbfHFkUkn19DkDk3i0vnnbM45zx%2B7%2B0Vp1ynhRWpUP7CG0ZYfHPMJ5ud5TIrrZsfj2XljET6mh4A%2BcO9omXpfTCUB0BEfC%2B6ag5LoV7FiW7bRKmD0UjvDozQfWiwAPVzkw7%2B4eBkjZgG%2BikGSlp9nKN8eA0%2F%2BObV6AH3%2Bv6KzCdd6r7SZPhobSHFC3w0cRYgLAO3UBfoNMlBL8F4Vzzc1c9TChUI6S1NIA7B6UjNwZwWn52tAU%2BgkI0M0n%2BwiX8PXZK9CLbCqj4CdrlQGIMlWCiN5ja0cQ2I1o2AIGGiMrZcTGRZdXkF9HyXR9m4K8IIzRxupGdWdHxYLYDSpxwQL9Qdkf6RNmY1yzh9%2FdjSYoopBb0iDZYWx%2FiID7dHhjN7RAX5FZKZuerqufo%2FtK2ZZY0eKuHn1DIu2t2mZeVblTcYU4jrvAcEsazzqRS4u3R%2FeGhVGgDYeoLyhzfCwPQXPus4Og20pUPE03%2BJW6tcG%2Fqds%2BcyS4KCxSg3D6z%2B%2F6jnJs8BsOvajJfb9VfZxSZe2r9s%2By4VlvA0JekCy0JXskiRmehPkrSxcXfizEo47fqg0SRo2vGvq2wtilW9pSQvT6LJayLfnh1ulL7gXJ3d43bg07TmBg58tMAqnTcW7t8RwS7zhl%2FQnUxpkqqxct58Wu0DXCPc%2FDAW15saaBOp%2B7pHcJ9djgTr6bQa7Ey%2BMm5TJIM2cX%2Fz9k%2BGRJYXQvBWzFL7XTq6BCV%2FPVsgIm017ScF8yX6BNicR7FK0wc%2FfVDP2CjLC6cMr%2BZp9yblHae0MrI65OvshrTxW2sxPS%2BSMIH%2Fq8kGOrABgVOY%2B4IvZb81nOCDxN1KUdcVx%2FgKPrE3G%2Fw9QXxl7i3HIFAOkbSr0PShNaS8bUJKlusQL9fwAtnJZrkIg7Zj9M4QU85X6VoMhkkX2pupaALwoPE1ir5obewYBJOAlL%2BHy1jIL6rddwMQYZ3mFg72eLhXNfH1m6nENMhslnz3AlSyRQw%2FoR4RidE0YRyP1IY833%2Byy2z6Ix%2F0BPAfytKHgkAcy0LDRF9r9qcaqGQMXA4%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20251129T144926Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=ASIAQ3PHCVTY4OXRYDN4%2F20251129%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=9bc21ea019d0f4a4c470baa01dd25c8588d52f3ee51a43e33b5878daf9e0eb9c&hash=2db4a7a399ea367a512659a94de8406dc616a63e698703875e88cc282549b0b9&host=68042c943591013ac2b2430a89b270f6af2c76d8dfd086a07176afe7c76c2c61&pii=S0164121224002322&tid=spdf-d4718126-41c6-466e-8ca2-7f4da5071381&sid=db3ceb25134c344ab7183050dee060ede648gxrqb&type=client&tsoh=d3d3LnNjaWVuY2VkaXJlY3QuY29t&rh=d3d3LnNjaWVuY2VkaXJlY3QuY29t&ua=1312560453570557515b51&rr=9a62e9651a030e05&cc=it)


L'articolo introduce il concetto di **Dynamic Language Product Lines (DLPL)** come un approccio alla modernizzazione del software basato sulla modularità e riconfigurabilità dei linguaggi di programmazione. Una DLPL è simile a una **software product line**, ma applicata ai linguaggi: consiste in un insieme di varianti di un linguaggio, ognuna con caratteristiche o funzionalità diverse, che possono essere selezionate e combinate dinamicamente a runtime. Questo permette di adattare il linguaggio alle esigenze specifiche di un'applicazione legacy, integrando nuove funzionalità senza dover riscrivere completamente il sistema.

I **micro-linguaggi** sono i mattoni costitutivi di una DLPL. Si tratta di piccoli sotto-linguaggi modulari che implementano funzionalità specifiche o domini particolari del linguaggio principale. Ogni micro-linguaggio può essere sviluppato e testato separatamente e poi combinato con altri per estendere o modificare il comportamento del linguaggio principale. In pratica, i micro-linguaggi permettono di creare versioni personalizzate del linguaggio target in modo incrementale, rendendo possibile la migrazione graduale del codice legacy verso sistemi moderni senza interrompere il funzionamento complessivo. Questo approccio facilita la transizione step-by-step, riduce i rischi legati alla riscrittura completa e supporta la coesistenza tra codice legacy e codice moderno.

Un esempio pratico di Dynamic Language Product Line (DLPL) e micro-linguaggi può essere illustrato con un sistema legacy in **COBOL** che deve essere modernizzato e integrato con funzionalità Java.  

Supponiamo che il sistema legacy gestisca diverse operazioni finanziarie: calcolo degli interessi, gestione conti correnti e reportistica. In una DLPL, ogni funzionalità può essere rappresentata come un **micro-linguaggio**:

- **Micro-linguaggio per interessi**: definisce le regole e le operazioni necessarie per calcolare gli interessi sui conti.
- **Micro-linguaggio per conti correnti**: gestisce le operazioni di deposito, prelievo e saldo.
- **Micro-linguaggio per reportistica**: permette di generare report in formato moderno, compatibile con il sistema Java.

Usando **Neverlang**, si possono creare questi micro-linguaggi separatamente e testarli isolatamente. Poi, a runtime, la DLPL combina i micro-linguaggi necessari per eseguire l’applicazione completa, consentendo così al sistema di supportare sia codice legacy COBOL sia nuove estensioni in Java senza riscrivere l’intero programma in una sola volta.  

In questo modo, il sistema evolve **gradualmente**, minimizzando rischi e interruzioni, e gli sviluppatori possono migrare funzionalità critiche prima di quelle meno rilevanti, tutto grazie alla modularità dei micro-linguaggi.



---commento Andrea Elia----
questo e' un approccio su come agire nel caso di modernizzazione di sistemi legacy. Non rappresenta un tools per la riconversione di sistemi legacy, tuttavia potrebbe esserci di grande aiuto appena capiamo su quale strada proseguire.


---

## [TRANSFORMING SOFTWARE ARCHITECTURE: A STRANGLER FIG PATTERN APPROACH](http://www.icicelb.org/ellb/contents/2025/8/elb-16-08-08.pdf)

Pattern utilizzato per la migrazione graduale di applicazioni legacy da architettura monolitica ad architettura a microservizi

![alt text](./figures/strangler_fig_pattern.png)

Utilizza un gateway per indirizzare le richieste al corrispondente microservizio se pronto e funzionante

---

## [Expert system for automatic microservices identification using API similarity graph](https://www.scopus.com/pages/publications/85139558704?origin=resultslist)

---

## [Improving microservices extraction using evolutionary search](https://www.scopus.com/pages/publications/85134792906?origin=resultslist)
