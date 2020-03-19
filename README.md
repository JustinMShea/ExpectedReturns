# gsoc-2020-Expected-Returns-Ilmanen

## Background
[ARPM](https://www.arpm.co) is an education firm founded in 2010 by Attilio Meucci. 
ARPM teaches the [ARPM Bootcamp](https://www.arpm.co/bootcamp/), a 6-day, 500+ people onsite (NYC)/online course and networking experience which consolidates portfolio managers’ and risk managers’ expertise into a rigorous quantitative framework.
Over the past years, ARPM has built the [ARPM Lab](https://www.arpm.co/lab/), an online e-learning platform that contains theory, case studies, simulation clips, toy examples, summary slides, video lectures,  code (Python/MATLAB), documentation, exercises, and more.

The goal for this project is to convert the Python functions currently in the ARPM Lab into R, with particular attention to two parts:
* The “Checklist” (10-step approach for integrated quantitative risk and portfolio management) 
* Factor Models and Learning (Multivariate statistics and machine learning for finance)

Students engaged in this project will obtain a deep understanding of
i) Data science for finance
ii) Quantitative risk management
iii) Quantitative portfolio management across asset management, insurance, and banking.


## Related work

This project takes its inspiration from previous GSoC projects in 2012, 2013 and 2014, as well as the new interactive [ARPM Lab](https://www.arpm.co/lab/).

Meucci's innovations include Entropy Pooling (technique for fully flexible portfolio construction), Factors on Demand (on-the-fly factor model for optimal hedging), Effective Number of Bets (entropy-eigenvalue statistic for diversification management), Fully Flexible Probabilities (technique for on-the-fly stress-test and estimation without re-pricing), and Copula-Marginal Algorithm (algorithm to generate panic copulas).

The development version of the functions backing the [ARPM Lab](https://www.arpm.co/lab/) scripts is available at https://github.com/R-Finance/Meucci.

We envision the following steps for this project:

* Familiarization with the theory of a topic
* Work with the GSoC mentor(s) to lay out the script for that topic
* Write core script functions, which will then be used on the ARPM Lab
* Complete minimal documentation

The project will be developed with https://www.rstudio.com/ and stored on https://github.com. In order to efficiently manage the development of the package, the various tasks and deadlines will be managed via https://asana.com/.

## Mentors

Erol Biceroglu, Prof. Brian Peterson, Prof. Dr. David Ardia, and Prof. Dr. Attilio Meucci.

## Tests

The official test for this project can be found [at this link](https://drive.google.com/file/d/0Bx2D7if2YYptOW1VLXp1bTBMOExZOFhtWWJ3UGhSd0FtUlJj/view?usp=sharing).

In addition to the test above, applicants should demonstrate that they have:
* A very good working knowledge of programming in R, (with the potential to use Rcpp and C++). 
* A very good working knowledge of Roxygen for the documentation.
* Familiarities with the construction of R packages.
* Good coding standards (Google’s C++ and R style guide).
* Good knowledge of Meucci's methods
* Experience with multivariate statistics
* Experience with GitHub
* code for the ARPM package will be released under the [Affero Gnu Public License](https://www.gnu.org/licenses/agpl-3.0.en.html)

## Solutions of tests

Students, please post a link to your test results here.

Zhang Shuai, https://github.com/zhzhzoo/meucci-test

## References

Meucci, Attilio. 2005. “Risk and Asset Allocation.” Springer Finance Textbooks. https://www.arpm.co/book/.

Meucci, Attilio, Fully Flexible Views: Theory and Practice (August 8, 2008). Fully Flexible Views: Theory and Practice, Risk, Vol. 21, No. 10, pp. 97-102, October 2008. Available at SSRN: https://ssrn.com/abstract=1213325
