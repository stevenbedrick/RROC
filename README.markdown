RROC: Dead-simple ROC analysis in Ruby
==========

Ported from the [ML-Mathematica](http://www.bioinf.jku.at/software/ML-Math/) set of machine learning demos.

This class provides methods for Reciever Operating Characteristic (ROC) calculation; algorithm copied from the ML-Mathematica[http://www.bioinf.jku.at/software/ML-Math/] mathematica library by Steven Bedrick ([steve@bedrick.org](mailto:steve@bedrick.org)). For an excellent overview of ROC analysis, check out:

Fawcett, T. "An introduction to ROC analysis" Pattern Recognition Letters 27 (2006) 861-874 [(pdf)](https://cours.etsmtl.ca/sys828/REFS/A1/Fawcett_PRL2006.pdf)

Installation
--------

    gem install rroc

Usage
--------

Using RROC is very simple. It expects to be given data in the form of a _n_x2 matrix (i.e., an Array of 2-element Arrays) representing the output of a binary classifier. Each row represents a "case" (document, data point, etc.); the first column represents the classifier's discriminant value and the second column represents the ground-truth class label for that case. RROC expects class labels in the form of either 1 or -1; larger discriminant values should be associated with membership in class 1. You can determine the area under the ROC curve as follows:

    require 'rroc'
    
    my_data = open('some_data.csv').readlines.collect { |l| l.strip.split(",").map(&:to_f) }
    auc = ROC.auc(my_data)
    puts auc
    
If you want to obtain a set of points describing the ROC curve itself, you can do that by calling the `ROC.curve_points` method:

    require 'rroc'

    my_data = open('some_data.csv').readlines.collect { |l| l.strip.split(",").map(&:to_f) }
    pts = ROC.curve_points(my_data) # returns something like: [[0.0, 0.0], [0.1, 0.01]... ]
    
The points are returned as an Array of two-element Arrays, each of which contains an X and a Y coordinate that you may then export or plot using the utility of your choice. For example, together with the `googlecharts` gem, you can obtain a Google Chart link that will display your ROC curve:


    require 'gchart' 
    require 'rroc'

    my_data = open('some_data.csv').readlines.collect { |l| l.strip.split(",").map(&:to_f) }
    pts = ROC.curve_points(my_data)
    puts Gchart.scatter(:data => [pts.collect { |x| x[0] }, pts.collect { |x| x[1] }])

Conclusion
---------
RROC is designed to be a tool for bare-bones ROC analysis in Ruby; take it for what it is and use it at your own risk. Bug reports, forks, and patches are more than welcome!

License
----------
Copyright (c) 2011, Steven Bedrick
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

