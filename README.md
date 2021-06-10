Code for CTRAMER v 1.0.0

Software is divided in five modules, each of which focus on a specific calculation
1)	Module 1: Molecule-level electronic structure calculations
	a)	RUN_DFTFUNC.sh calculates ground state charges for each molecule
2)	Module 2: Condensed-phase molecular dynamics simulations
	a)	Contruct_layers.sh constructs semi-random condensed-phase systems by tessellating individual molecules
	b)	Generate_gs_prmtop.sh assigns the parameters and topology from Module 1 to each molecule in 2a.
	c)	Run_md.sh generates multiple parallel production runs for the system after equilibration.
3)	Module 3: Molecular pair-level electronic structure calculations
	a)	RUN_DFTFUNC.sh calculates excited state characteristics for each pair selected from Module 2
	b)	Analyze_states.py selects the important states and transitions from 3a.
4)	Module 4: Fixed pair molecular dynamics simulations
	a)	Generate_prmtop.sh creates the files necessary for MD for each state from Module 3
	b)	Recalculate_ex.sh
		i)	ct_trajectory creates a trajectory for each donor state in selected transitions with the chosen pair fixed
		ii)	ct_recalculate recalculates the energy at each step for each state in the transition
5)	Module 5: Linear semi-classical rate constant approximation
	a)	Calculate_corrections.sh calculates the energy correction term for each state
	b)	km_calc.sh calculates the rate constants for each transition
