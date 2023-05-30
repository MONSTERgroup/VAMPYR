# VAMPYR
**V**PSC **A**utomation in **M**TEX for **P**olycrystal **P**lasticit**Y** **R**esearch

A toolbox for running and automating the Viscoplastic Self-Consistent (VPSC) model using MATLAB, depending on the MTEX crystallographic toolbox.

Current dependencies:
- VPSC7 ([VPSC8](https://github.com/lanl/VPSC_code) compatibility forthcoming)
- MTEX 5.8 or newer

`startup_api()` adds the source code in the [VPSC](VPSC) folder to the MATLAB path. `shutdown_api()` removes that source code from the MATLAB path. In order to make full use of the VAMPYR API, MTEX will already need to be installed and started.

`RunTextScript.mlx` demonstrates the basic functionality of the API.

Right now, this repository serves as minimum product to demonstrate the core features necessary for automating VPSC. Further updates are planned in the near future to add additional features and to improve/extend documentation and demonstrations.
