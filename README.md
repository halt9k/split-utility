# Split utility
This 3dsMax utility script was created around 2014 to help\improve legacy workchain difficulties.  
Workchain implied exporting 3ds Max models to separate files=parts for consequent in-program usage.

Details:  
\* = label on attached image
- Models had mostly no distinct edges (mostly curved) and had high amount of poly's for 2014 (~50 000).

- As an example, how workchain divided model, there are 3 parts on image: p1*, p2*, p3*.  
Actual amount of parts was around 150, i.e. it was not possible to do proper check-ups manually.  
It was additionally required for some seals to be independent, i.e. to be able to load in program only some sets of parts.  

- It was required for some tasks to completely join model and to work with it like with solid seal-less object.  
This means dividing it back before or during export.

- While seals like s2* provide little difficulty during these operations, in many scenarios seals like s1* were strong problem.  
Normals on them were displaced during modelling in Max (especially during Weld - UnWeld),  
default import-export also implicitly changed them and model after import had seals like s1'*

- It was necessary to check/prevent a number of possible human mistakes like
hanging vertices, hanging edges on seals, unoptimized model parts, incorrect/inconsistent names, etc

However, this script was used just necessary number of times and pair of experimental options were never finished.
Nowadays (2020) approach itself/methods are probably inoptimal.

![Highlights:](https://github.com/halt9k/split-utility/blob/main/Desc/Desc.png?raw=true)
