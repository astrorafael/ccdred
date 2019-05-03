# ccdred
Classical 2-D monochrome CCD reduction pipeline using IRAF and TCL/Tk templates to customize CL scripts

This document briefly describes the intended use of the software so others
may adapt or modify it according to their needs. Enjoy.

# B. INSTALLATION


Needs Tcl/Tk 8.3 or higher.
Assume that IRAF, DS9 and XPA utility programs are already installed.
Simply unpack this tarball into your $HOME directory. 
A new 'ccdred' subdir is created. 

# C. BEFORE YOU BEGIN ...

Performing an automated reduction procedure involves a few assumptions
on how to name images, how to store and handle them. 

Here are the assumptions made by this package:

     1) The home directory to store CCD images is $HOME/ccd

     2) This package deals with a batch o images taken into a single night. 
     To avoid conflicts when dating the images, julian dates are used to 
     name directories. Thus, a single directory will containg images taken
     before and after midnight.

The working directory for a single night is $HOME/ccd/<julian day>. 
We'll refer to the working directory often in this doc.

      3) Set of images can be efficiently handled if they assume the following
      naming convention:

         <prefix>_<XX>_<NNN>.fit

where <prefix> is the image prefix (see below), XX is a hexadecimal 
two digit number and NNN is a decimal three-digit number. XX specifies
the image group identifier (a group of darks, flats, etc.). NNN is the 
sequence number in the group. Examples are given below.
XX is never duplicated in the batch of images residing in the same directory.

      4) Calibration images have the following prefixes:

      * zero_ for bias images
      * dark_ for dark frames
      * flat_ for flat_fields

      These calibration prefixes are inspired in the IRAF IMAGETYP nomeclature.
      Science frames have <object>_ as prefix, where <object> can be 
      anything but the calibration prefixes.
      
      A simple run:

      zero_01_001.fit
      zero_01_002.fit
      zero_01_003.fit

      dark_02_001.fit
      dark_02_002.fit
      dark_02_003.fit

      m82_03_001.fit
      m82_03_002.fit
      m82_03_003.fit

      flat_04_001.fit
      flat_04_002.fit
      flat_04_003.fit

      m82_05_001.fit
      m82_05_002.fit
      m82_05_003.fit

      Note that the series identifier XX is never duplicated and allows 
      identification of separate sets of images, even for the same object m82.

      5) FITS IMAGETYP

      The file name conventions above were made for the Tcl scripts.
      However, IRAF relies heavily on the IMAGETYP keyword and its 
      normalized values. Be sure that all of your images include the 
      proper IMAGETYP value, the IRAF way. In particular, the so 
      called Amateur FITS Standard sponsored by SBIG does not follow 
      these values.

# D. PROCESS OUTLINE

The automatic reduction performs these basic steps

1) Image classification based on resolution
2) Master Calibration Files production
3) Science frames reduction
4) Image Registration (stacking)

## 1. Image Classification

Batch processing of images can only occur for images with the same resolution.
As the adquisition program may have taken images with different binning, a
preliminar classification process is necessary.

From the image working directory two subdirectories are created:
"raw" and "reduced". The "raw" subdir contains a backup copy of all images
taken. The reduction process can be recreated using the backup copies.
The "reduced" directory initially contains the same images as the "raw" 
subdir.

For each subdirectory (raw & reduced) several subdirectories are made
acccording to resolution. Thus, if the working directory contained a 
mix of 798x520 and 396x240 images, the following subdirectories would be 
created:

    - $HOME/ccd/<julian day>/raw/798x520/
    - $HOME/ccd/<julian day>/raw/396x240/
    - $HOME/ccd/<julian day>/reduced/798x520/
    - $HOME/ccd/<julian day>/reduced/396x240/

After image classification, images will never reside at the top level of
the working directory. Instead, auxiliary text files will be placed at 
this top level.

To start all over again, just use the purge script This will
erase all images from the "reduced" directory and will copy the images from
the "raw" subdir. Auxiliary text files will also be deleted.

## 2. Master Calibration File Production
 
This step in the process tries to automatically produce the calibration files 
needed based on the image namimg convention shown above. If the calibration
master files exist, nothing is done. Otherwise, it looks for series of bias
dark and flat frames to produce the masters.

From the example given in the previous section, 
the following masters would be produced:

Zero_01.fit
Dark_02.fit
Flat_04.fit

IRAF's ccdred logfile can be reviewed for the details. This logfile resides on
the working directory..

It would be possible to have two series of dark frames as candidates for 
Master Dark. The series with the longest number of images is chosen.

This step and the heuristics involved is - in my opinion - what IRAF lacks
to make automatic reductions possible.

## 3. The Catalog

The master file production pipeline may check for existing master bias or darks
in a catalog directory. This directory is:

$HOME/ccd/catalog

and it is further split into subdirs by resolutions.
There must be ONLY ONE master file per resolution.
By default, catalog usage is disabled. If enabled, the production of
master files is as follows:

- Reuse existing master files in the working directory
- Reuse existing master files in the catalog
- Combine individual files  in the working directory.

The GUI application tkccdred.tcl has options to enable/disable the catalog and
to update the catalog with the master files produced in a working directory.


## 4. Data Reduction

Data reduction intelligence is mostly carried out by IRAF in this step.
Given the proper master frames, IRAF knows how to handle them and performs 
science frame reductions.

There is one common case where thses scripts will fail.

If your observation is made of scienc, darks, flats and flat darks and no bias
frames are taken (nor overscan strips are available), then these scripts
cannot tel darks from flat dark There is no 'flatdark' prefix nor image type. 

Scaling dark frames to match usually shorter flats is mathematically 
incorrect if no bias frames are taken.

Solution: take bias frames.

## 5. Image Registration

This step is optional, for not all science frames need to be registered.

A new 'register' subdirectoy under the working directoty is created.
Series of science frames will all be registered whether it makes sense or not.
Single images not belonging to a series will not be registered.

Registration is performed by the IRAF task 'xregister', performing
cross-correlation analysis for linear shiftsin both axes. The reference
image taken is the middle image in the series.

After registration is done, images are combined to produced a 
master science frame.

Details on the registration process can be reviewed on the IRAF's logfile

## 6. Image combination

Individual, reduced and optionally registered science frames can be combined
by either averaging or median combining.

The combination process can use an optional sigma clipping algorithm to reject
outlier pixels. Several rejection methods are available in IRAF but only
two of them are used:

- the classical sigma clipping
- an averaged sigma clipping

See the details of these algorithms in IRAF (help imcombine).
The selection is automatically made upon the number N of images to combine.
If N > 10 use the classical sigma clipping, else use the averaged sigma 
clipping. 

There is not yet provision to use the best statistical rejection
algorithm based on CCD's gain and readout noise parameters.


# USING THE SOFTWARE

The main scripts are:

purge.tcl    - CLI that purges the image working directory to start 
         all over again.
ccdred.tcl   - CLI that performs master calibration files construction 
         and science frames reductions.
stack.tcl    - CLI to peform science frames registration (image stacking)
         and displaying of combined images 

These must be taken as examples for batch processing and will not be updated.

tkccdred.tcl - a simple Tk GUI front-end.


# IRAF TEMPLATES

I have found many problems trying to use the "IRAF Scripting Host facility".
Passing information from an external program to IRAF tasks does not work very
well. So I took an approach like Dynamic HTML generation. Under the 'iraf/'
subdirectory are IRAF template .tpl files, converted to proper IRAF .cl 
scripts and then executed invoking 'cl'.
This has proved very flexible and convenient.
