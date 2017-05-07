# bert
a neural network based simulation of a c elegans written in erlang
I've used intelij for this project but if you wish to run it independant of an ide then make sure to change the path of berts map file to one relative to main.erl on line 9
or use this N=util:makeNurons("../maps/bert.map"),
then compile all files before running main:main()
once the simulation starts you can press enter to stop the rendom firing of neurons and again to halt the simulation
