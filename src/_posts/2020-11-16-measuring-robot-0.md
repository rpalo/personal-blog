---
layout: page
title: 'Building an Automatic Measuring Table: Part 0'
description: Introducing a new project.  I'm building a robot table/tape measure!
tags:
- robotics
- python
- mechanical
- woodworking
cover_image: T4P-M345R.png
---

You say, “Measure twice, cut once.”  I say, “Measure zero times, cut once.”

My robotics course this semester has a term project where we are required to model and/or build a robot of some kind. I’ve decided to journal the process to document things in a more personal way than the final report ever could. And because I’m really excited to share a process that will end up combining mechanical engineering, programming, and wood working.

## The Project

The project I’ve decided to undertake is an automated measuring table to help with the wood working projects that my wife and I do. I think it will have a tabletop made of free rollers, with a “measurement head” that has a laser gate for detecting the edges of boards, a laser line, and a drive wheel that will drive the boards through. 

The user will put the number of inches they need and feed in a board. The machine will detect the edge of the boards and then advance it the desired number of inches. Once the machine stops, the proper spot should be under the laser line, and the user can mark the point without ever reaching for a tape measure. 

Here’s my initial design sketch (click for bigger image):

<a href="/img/robot-design-sketch.png">
![My initial design sketch showing my first thoughts for requirements.](/img/robot-design-sketch.jpg)
</a>

I'm sure the final design will be a good amount different than this, but the sketches lay out my initial thoughts for requirements and functionality.

It seems like a good, balanced project.  Since I'm already working full-time, turning in all the other work in the class, and parenting a 18-month-old, I wanted to choose something that I wouldn't have to put a huge amount of consecutive hours into.  But I also wanted to build something complex enough to be reasonably impressive, something that was actually useful rather than an  AI-driven doodad, and something that utilizes some of my mechanical design skills.

I'm lovingly calling the project **T4P-M345R** (tape-measure), and I'm pretty proud of that.

As you can see, there are still several question marks, even in the requirements of the design.  This leads me to the next section:

## The Schedule

As part of the project proposal, we had to generate a schedule of how we thought the project would break down.  I'm putting mine up here for accountability's sake.  You should hopefully expect to see a journal entry a day or two after each deliverable.

- **11/20/2020 (5 days)**: Finalize design requirements.
- **11/22/2020 (2 days)**: Finish CAD design for robot.  Generate Bill of Materials and order any items that need to be shipped to me.  Generate design drawings for the build.
- **12/05/2020 (9 days + holidays)**: All components should be in-house.  Complete rough draft of programming.  Complete cuts for table frame.
- **12/11/2020 (6 days)**: Complete table build.
- **12/13/2020 (2 days):** Complete measurement head build and programming.
- **12/18/2020 (5 days)**: Complete final testing and debugging.  Prepare pictures and videos for project submission.
- **12/20/2020 (2 days)**: Submit final project deliverable package, complete with report.  Also prepare for CHRISTMAS!

## Deliverables

The full final project will have the following deliverables:

- Formal list of design requirements
- Complete design drawing package for parts and assembly
- Bill of Materials
- Pictures and video of final product in action
- Source code for controller
- Wiring diagram (for dummies, I'm a mechanical engineer, not electrical 😁)

Stay tuned and let me know if you have any ideas or questions along the way!