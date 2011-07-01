# This class provides methods for Reciever Operating Characteristic (ROC) curve calculation; algorithm copied from the ML-Mathematica[http://www.bioinf.jku.at/software/ML-Math/] mathematica library by Steven Bedrick (steve@bedrick.org). For an excellent overview of ROC analysis, check out:
#
# Fawcett, T. "An introduction to ROC analysis" Pattern Recognition Letters 27 (2006) 861-874 (pdf[https://cours.etsmtl.ca/sys828/REFS/A1/Fawcett_PRL2006.pdf])
#
# first col of mat is discrim. val; second col is label (+1 -> pos, -1 -> neg, higher disc. val -> more pos)
#
# e.g.: +[[.3, -1], [.7, 1], [.1, -1] . . . ]+
#
# The scale of first column is not important. The labels in the second column are.
#
# pts plot fpr (x-axis) against tpr (y-axis)

class ROC
 
  # Calculates the "area under the ROC curve" for the output of a binary classifier.
  #
  # @param [Array] dat Classifier output for which the AUC should be calculated, in the form of a n x 2 matrix. Each row represents a "case" (document, example, etc.); the first column is the discriminant value, and the second column _must_ be either -1 (if the ground truth class of the case is "negative") or 1 (if the ground truth is "positive").
  # @return [Fixnum] The "area under the ROC" curve.
  def self.auc(dat)
    return self.calc(dat, false)
  end
  
  # Returns a set of x/y coordinates describing an ROC curve for +dat+ plotting the FPR on the abscissa and the TPR on the ordinate. 
  # @param dat (see ROC.auc) 
  # @return [Array] x/y coordinates that, when plotted, illustrate an ROC curve for +dat+. Each element in the array is an array containing an x and y coordinate.
  def self.curve_points(dat)
    return self.calc(dat, true)[:points]
  end
  
  private 
  def self.calc(mat, inc_pts = false)
  	# sort by first col, ascending, and take labels
  	sorted_by_disc = mat.sort { |a,b| a[0] <=> b[0] }
  	sorted_labels = sorted_by_disc.collect { |d| d[1] }
	
  	# now let's count the number of positive and negatives:
  	pos = sorted_labels.count { |l| l == 1 }.to_f 
  	neg = sorted_labels.count { |l| l == -1 }.to_f

  	auc = 0.0
	
  	plotlist = [[0,0]]
	
  	if pos > 0 # are there *any* true positives? If not we can't really calculate much...
  		c = 0.0 # how many positives we've seen thus far
  		n = 0.0 # how many negatives we've seen thus far
  		(sorted_labels.length - 1).downto(0) do |i| # walk backwards through the data...
  		  if sorted_labels[i] > 0 # pos?
  			  c += 1.0
  		  else
  			  n += 1.0
  			  auc += (c / (pos * neg)) # update auc
  		  end
  		  plotlist << [n / neg, c / pos]
  		end
  #		plotlist << [1,0] # the original MMA has this, but I don't think we really need it.
  	end
	
  	if inc_pts # does the caller want x/y points describing the curve?
  	  return {:auc => auc, :points => plotlist}
    else # if not, just return the auc
  	  return auc
    end
  end
end


