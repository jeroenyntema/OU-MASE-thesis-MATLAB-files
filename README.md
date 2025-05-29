# MATLAB code (.m files) for creating, pre-processing and labeling of I/Q data sets

## Context

These MATLAB .mat files contain code that has been created as part of a thesis for the master degree Software Engineering.
In the research for the thesis, raw IQ data of different devices was captured with an ADALM PLUTO SDR. The data is then processed in MATLAB and classified with different CNNs, with the purpose of evaluating how accurate the CNNs can classify signals whose properties only differ on higher levels of the OSI model.
The code has been placed on github to make sure it does not go lost, but also to make the research auditable and allow data to be inspected by those reviewing the thesis.

## Contents

The are a total of 8 files that create four different types of CNN. These CNNs are created once with a setup for complex data, and once with a setup for real and imaginary values in two channels.

The files m1, m2 and m3 take raw captured IQ data and make it ready for pre-processing. The files m4, m5 and m6 do the pre-processing. The data is then selected into equal numbers (m7) and labeled (m8).

There are two separate scripts that create the confusion matrices that show the accuracy of the trained models.

The MATLAB commands to train the models are not included in these scripts.

## License

This dataset is licensed under the Open Data Commons Attribution License v1.0 (ODC-BY: https://opendatacommons.org/licenses/by/1-0/). Which means you are free to share/copy/distribute as long as you attribute public use or works produced from the dataset in the manner specified in the license (giving appropriate credit, providing a link to the license and indicating if changes were made).

