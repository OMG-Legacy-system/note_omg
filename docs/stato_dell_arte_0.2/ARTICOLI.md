# Feature extraction
## Non Model Driven
### [The effect of 3D visualization on mainframe application maintenance: A controlled experiment](https://www.scopus.com/pages/publications/85015829702?origin=resultslist)
![alt text](./imgs/3d_Visualization.png)
The proposed system aims at establishing a static 3D call graph
model for COBOL programs using virtual reality modeling language. It receives the file having the function source code from
the end user and establishes all functions and sub functions called
by that function as a 3D model using VRML.

### [A demand-driven approach to slicing legacy COBOL systems](https://www.scopus.com/pages/publications/84863322306?origin=resultslist)
This paperproposes a novel static program slicing approach, which is based on context-sensitive token propagationover control ﬂow graphs (CFGs). CFGs require less space compared with program dependence graphs(PDGs) used by other techniques, and the token propagation method computes the necessary informationonly, on demand. Algorithms are presented for data ﬂow and full slicing to calculate precise program slices.Preliminary application experiences on industrial-scale COBOL systems are also summarized

### [Mining Association Rules from Code (MARC) to support legacy software management](https://www.scopus.com/pages/publications/85077041210?origin=resultslist)
Mining association rules from code (MARC) is a software engineering technique that analyzes source code to identify patterns, dependencies, and relationships between program entities.
This paper presents a methodology for Mining Association Rules from Code (MARC),
aiming at capturing program structure, facilitating system understanding and supporting
software management

### [Multi-language re-documentation to support a COBOL to Java migration project](https://ieeexplore.ieee.org/abstract/document/7884669)
Re-documentation is a subarea of reverseengineering where the intent is to recover lost or non-existentdocumentation in from of a semantically equivalentrepresentation within the same abstraction level such as dataflow, data structure and control flow [7, 8]. These alternativeviews of the software can be generated automatically. Indeed, alot of tools [4, 8, 9] which generate such alternative views fromsource code of legacy systems are available today. Those toolswere successfully used for maintenance of legacy systems [4]as well as support of software migration following anautomatic transformation strategy [8] or manual reimplementation of a legacy system [9]. Also commercial toolssuch as COBOL FGM (www.proetcon.de) generatedependency graphs, data flow graphs, and metrics fromCOBOL source code.

# Migration Strategies and Methods
### [Bottom-up and top-down cobol system migration to web services](https://www.scopus.com/pages/publications/84875739471?origin=resultslist)
Moving from mainframe systems to a service-oriented architecture (SOA)
using Web services is an attractive but daunting task. The bottom-up or directmigration approach enables the effective modernization of legacy systems to
Web services. Conversely, bringing migration into fruition with the top-down
or indirect-migration approach is more difficult, but it achieves better migration
results. Employing both approaches on the same large enterprise system is
uncommon, which leaves no room for comparison. This article describes the
migration processes, costs, and outcomes of applying both approaches on a
real Cobol system.

### [Re-implementing a legacy system](https://www.scopus.com/pages/publications/85066271675?origin=resultslist)
Re-implementation is one of the alternatives to migrate a legacy software system next to conversion, wrapping and redevelopment. It is a compromise solution between automated conversion and complete redevelopment. The technical architecture can be revised and the code replaced, but the functional architecture – the use cases remains as it was. The challenge of this approach is to preserve the functionality while changing the technical implementation. This approach is taken when conversion is not feasible and redevelopment is too expensive or too great a risk. It entails more than a 1:1 transformation but less than a total rewrite. The same components remain with different contents. In this paper the case for reimplementation is presented and the process described. The tools required to support the process are identified and their use illustrated. Finally, two industrial case studies are presented, one with a VisualAge/ PL/I-DB2 system and one with a COBOL-IMS application.

### [COBOL systems migration to SOA: Assessing antipatterns and complexity](https://www.scopus.com/pages/publications/85064766311?origin=resultslist)
Assessment antipatterns of Web Services’ WSDL documents generated upon the three migration approaches. In
addition, generated Web Services’ interfaces are measured in complexity to attend both comprehension and
interoperability. We apply a metric suite (by Baski & Misra) to measure complexity on services interfaces – i.e.,
WSDL documents.

### [Migrating from COBOL to Java](https://ieeexplore.ieee.org/abstract/document/5609583)
![Cobol2Java Transformation process](./imgs/cobol2java.png)
This paper is an industrial report on a project formigrating an airport management system from a Bull mainframeusing COBOL as a programming language and IDS as a databasesystem to a distributed UNIX platform using Java and Oracle.The focus here is on the automated language transformation,performed in three phases – reengineering, conversion andrefinement. The tools used are COBRedo for reengineering theCOBOL code, COB2Java for converting COBOL to Java andJavRedoc for documenting the converted Java code. The paperdescribes the migration process and the tools used in it and thereviews the current state of the project. Keywords: Migration,Reengineering, Legacy systems, COBOL, Java, Object-orientedtransformation.

### [Efficient Platform Migration of a Mainframe Legacy System Using Custom Transpilation](https://ieeexplore.ieee.org/abstract/document/9609183)
![alt text](./imgs/transpilation.png)
In this report, we present the case of an insurance system with1M Source Lines of Code, running on an expensive mainframeand featuring Natural, Cobol, and Assembler code as well asan Adabas database. We elaborate on why state-of-practicemigration strategies were inadequate in this case and introducean alternative methodology, taking into account the limitedbudget for the migration.In this project, we use custom transpilation to translate thelegacy code automatically to another programming language. Incontrast to off-the-shelf transpilers, we implement an iterativelyrefined transpiler that is fine-tuned to the legacy code at hand.The transpiler guides its own development by pointing outinstructions in the legacy code it cannot yet translate. Manualadaptions to the legacy code allow circumventing the implementation of overly complicated translation rules. This ensures thetranspiler and the generated code remain lean and efficient whilebeing able to cope with specific challenges of the system at hand.In the presented industrial case, Natural and Assemblersources were transpiled to Cobol running on Linux, combinedwith some adapted and rewritten Cobol and Java. We illustrateour lessons learned and provide in-depth insights into testingand debugging activities. A comparison with alternative offers byother vendors validates the economic benefits of this approach.

# Altro
## Re-Ingegnerizzazione
### [Agile model-driven re-engineering](https://www.scopus.com/pages/publications/85196291052?origin=resultslist)
The objective is to support the reuse of business-critical functionality from such systems and the porting of legacy
code to modernised platforms, together with technical debt reduction to improve the system maintainability and extend
its useful life. AMDRE uses a lightweight MDE process which involves the automated abstraction of software systems
to UML specifications and the interactive application of refactoring and rearchitecting transformations to remove quality
flaws and architectural flaws



# Scartati

### [Legacy system migration approaches](https://www.scopus.com/pages/publications/84879919631?origin=resultslist)

L'articolo è in spagnolo, comunque parla di sistemi di migrazione diretta e indiretta, nel caso dalla tabella qualcosa si può recuperare
