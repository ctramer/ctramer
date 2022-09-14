Example data for CTRAMER

1)	Module 1: Molecule-level electronic structure calculations
	a)	xyz files for dbp and c70, used as inputs for Q-Chem
2)	Module 2: Condensed-phase molecular dynamics simulations
	a)	txt files are Mulliken charges from Module 1
	b)  pdb and mol2 files are input files for Packmol, to create AMBER input files
3)	Module 3: Molecular pair-level electronic structure calculations
	a)	xyz files for the four selected structures
4)	Modules 4 and 5: Fixed pair molecular dynamics simulations
	a)	All the necessary files for rate calculations
	b)  Output files from Module 4 are very large and include randomness, better to compare to results in paper


These files were used to generate the results in:

Jacob Tinnin, Srijana Bhandari, Pengzhi Zhang, Eitan Geva, Barry D. Dunietz, Xiang Sun, and Margaret S. Cheung, "Correlating Interfacial Charge Transfer Rates with Interfacial Molecular Structure in the Tetraphenyldibenzoperiflanthene/C70 Organic Photovoltaic System", The Journal of Physical Chemistry Letters 2022, (2022) https://doi.org/10.1021/acs.jpclett.1c03618

Please consult the following paper for a more detailed description of the features, architecture, guidelines for usage, and scientific justification of CTRAMER. When using CTRAMER, please cite:

Jacob Tinnin, Huseyin Aksu, Zhengqing Tong, Pengzhi Zhang, Eitan Geva, Barry D. Dunietz, Xiang Sun, and Margaret S. Cheung, "CTRAMER: An open-source software package for correlating interfacial charge transfer rate constants with donor/acceptor geometries in organic photovoltaic materials", The Journal of Chemical Physics 154, 214108 (2021) https://doi.org/10.1063/5.0050574