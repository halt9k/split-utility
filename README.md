# split-utility
This script was created around 2014 to help\improve legacy workchain difficulties.
Workchain implied exporting 3ds Max models to separate files=parts for consequent in-program usage.

Detailed description:	
	- Models had mostly no distinct edges (mostly curved) and 
		high amount of poly's for 2014 (~150 000)
	
	- As an example, how workchain divided model, there are 3 parts on image too: p1*,p2*,p3*
		Actual amount of parts was around 150, i.e. 
		it was not possible to do proper check-ups manually.
		It was additionally required for some seals to be independent, 
		i.e. to be able to load in program only some sets of parts.
	
	- It was required for some tasks to completely join model and to work with it 
		like with solid seal-less object. This means dividing it back before or during export.
	
	- While seals like s2* provide little difficulty during these operations, 
		in many scenarios seals like s1*
		were strong problem. They were displaced during modelling in Max (especially during Weld - UnWeld),
		default import-export also implicitly changed them and model after import had seals like s1'*

	- It was necessary to check/prevent a number of possible human mistakes like
		hanging vertices, hanging edges on seals, unoptimized model parts, incorrect/inconsistent names, etc
		
	*labelled on attached image

However, this script was used just necessary number of times and pair of experimental options were never finished.
Nowadays (2020) approach itself/methods are probably inoptimal and outdated.

This is demo of diversity of finished tasks and ability to work in unfamiliar areas rather than Maxscript proficiency.
I rarely faced Maxscript before or after that task.
Maxscript debug and even googling was more limited in 2014 than now, so task was trickier.
Some attempts were made to keep code clean and it was slightly polished before publishing.
I'm also familiar with modelling process itself and can fix / create simple improvements in models.

![Highlights:](https://github.com/halt9k/split-utility/blob/master/Desc/Desc.png?raw=true)
