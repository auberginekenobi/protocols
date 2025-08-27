# Python basics tutorial

This tutorial has two purposes: to teach some basic concepts in programming and programming languages, and to show how they are implemented in the Python 3 language. To do so, we will consider a couple of common use cases one might encounter as a scientist:  
- **Running someone else's protocol**. In this situation, there is an accepted solution to your problem and high-quality software to solve the problem already exists. As an example, we will consider the *differential expression problem* use Python to run t-tests on 5 replicates each of experimental and control data.
- **Defining and solving your own problem**. Often in research we're working on the edge of what is known, and so the software to solve our problem either doesn't exist at all or doesn't quite meet our needs. In this case, we need to create our own software solution. As an example, we will write a program to solve the *reverse complement problem*: given a single-stranded DNA sequence, what is its reverse complement?

This tutorial assumes no formal programming or computer science background, but familiarity with molecular biology. It will be helpful but not required to have some familiarity with mathematical topics including logic, set theory, linear algebra and statistics. 

### Requirements
Materials are Jupyter notebooks. For instructions on how to install Jupyter, Python, and the required software packages, see [Tutorial 0](/0_Setting_up_your_workstation/README.md).

### Contents
**Tutorial 1.0 Python as a calculator** introduces numerical data types, variables, errors, functions, the `list` data structure, and the `math` and `scipy` software packages for statistics. By the end of this tutorial you should be able to run a statistical test using Python.  
**Tutorial 1.1 Text manipulation** introduces the `str` data type for text, iteration (`for` loops), and creating a function. By the end, you will have programmed a solution to the reverse complement problem below.  
**Tutorial 1.2 Control flow** introduces logic, the `bool` data type, `if` statements, and testing. By the end, you will write your own tests to verify that your reverse complement solution is correct.  
**Tutorial 1.3 Sets and tables** introduces sets, file input/output, the `pandas` package for data tables, and multiple hypothesis testing. By the end, you will be able to run many statistical tests and interpret them correctly.

## The reverse complement problem
**Definition**. Consider the DNA sequence
```
5'-GACTACAAAGACGATGACGATAAA-3'
   ||||||||||||||||||||||||
3'-CTGATGTTTCTGCTACTGCTATTT-5'
```
This representation highlights a few properties of DNA that will be familiar to a molecular biologist: first, it is *complementary*; every `A` pairs with `T` on the other strand, and every `G` with `C`. Second, it is *antiparallel*, meaning that the 5' to 3' orientation of each strand is in opposite directions. Together, these properties mean that DNA can be represented as a single string `GACTACAAAGACGATGACGATAAA`, since the sequence of the opposite strand can be inferred. However, sometimes it's important to get the complementary seqence, for example in primer design for a PCR, where we need to order a primer which is complementary to the sequence we actually want to amplify.

Think for a minute on how you would do that. If it were just 1 or 2 sequences, you might do it by hand. But if you needed a million primers..? Now you want a program to do that for you. There are of course programs already available motivated by this exact problem[^1], but it's a simple enough exercise that we will write our own:

*Reverse complement problem:*  
*Given a DNA sequence x, what is its reverse complement DNA sequence y?*  
Specifying "DNA sequence" avoids the ambiguity of a sequence having both DNA and RNA complements. We may further specify that we require the solution to be a function of the form *y=f(x)*.

**Solution**. Now that we have defined the problem, we can begin to implement a solution. The distinction here between problem, solution and implementation is worth noting. In the problem statement, we have mathematically defined what the inputs and outputs of our function should be, all without writing any code.  We could even specify a *solution*, sometimes called *pseudocode*, defining the specific steps required to solve the problem, *still without writing any code*. Finally, there is the *implementation*, using code written in a specific programming language, that actually performs the specified operation. If you're unfamiliar with a new programming language, it can help to have a clear idea of (1) what exactly your code will do and (2) how it will do that, which are largely independent from (3) the code in a specific programming language that performs the operations specified in (2). 

For example, with the reverse complement problem, we have already defined the problem above. We could even write pseudocode to solve the reverse complement problem as:
```
Given a sequence x:
reverse x;
complement x;
done
```
or equivalently,
```
Given a sequence x:
complement x;
reverse x;
done
```
noting that there may be multiple correct solutions to a given problem. Finally, we will cover the Python language concepts required to implement this pseudocode in Tutorials 1.1 and 1.2.

## The differential expression problem
**Definition**. Next, consider the following very common scenario. You are a scientist; you have two sets of observations, such as patient and control cohorts, or treatment and control groups of your cell line model. You want to know what's 'different' between the groups, and so you perform a high-throughput omics experiment such as RNA-seq. After some data processing, you now have a giant table of *n* samples each with *k* measurements of gene expression. Similar data may also be encountered with other high-throughput experiments such as protein mass spectrometry, ATAC-seq, ChIP-seq, single-cell, or spatial transcriptomics.

*Differential expression problem:*  
*Given a large table of *k* features across *n* observations, and annotations *a* associated with each *n*, which features in *k* are different w.r.t. sample groups specified by *a**?  

Or, more conversationally,

*Which genes are differentially expressed?*

**Solution**. This is a very common question, and there are many possible methods to answer it. These methods differ in the details, but the general idea is the same:
```
For each gene g in k:
Build a statistical model of g w.r.t. a;
Identify significantly different genes;
done
```

For RNA-seq, the current standard as of 2025 are the software tools DESeq2[^3] and edgeR[^4]. Both tools use generalized linear models (GLMs) to fit the data, making assumptions about the distribution of RNA-seq data, but these will be covered in a later tutorial. For our purposes, we will perform a t-test in Tutorial 1.0 to determine whether the distributions of *g* are significantly different between groups. Then, in Tutorial 1.3, we will do t-tests for every gene in *k*, and perform *multiple hypothesis correction* to account for having performed ~20,000 tests.

### A note on p-values and multiple hypothesis correction

This section introduces *multiple hypothesis correction*. If you're already familiar, feel free to skip it and get started with the tutorials. If not, read on.

Let's begin with the famous "p-value". You may have some intuition already about what it is and how to use it; mine is something like, "if $p < 0.05$, significant; if not, nonsignificant." But what how is *p* determined and what does it mean?

Most statistical tests start with a *null hypothesis* $H_0$ to the effect of, "there is no relationship between $a$ and $g$." Assuming $H_0$ is true (and usually making other assumptions too), we can construct a statistical model, or *null distribution*, for how our data would be generated. The *p-value* is defined as the probability that the null distribution generates a result at least as extreme as that observed in the given data. For example, the two-sample t-test we will perform in Tutorial 1.0 assumes that our data were drawn from 2 t-distributions with the same means. A p-value of 0.05 means that there is a 1 in 20 chance that those distributions could have generated data as unusual as our observations. This is unlikely, and so in that case we would have enough evidence to reject our assumption $H_0$ that the two groups have the same mean. However, the threshold of $p<0.05$ accepts some risk of *false positives*; ie., a 5% chance that we get a significant result even if no true difference exists.

Next, consider what would be the outcome if we did RNA-seq on biological replicates of the same sample under the same conditions, randomly partitioned into two groups. Since there is no biological difference, the null hypothesis is true and therefore any significant results must be false positives. If we were to do t-tests on all 20,000 protein-coding genes, we would expect $20,000 \times 0.05 = 1,000$ significant results, *even though no true difference exists between the groups*. Obviously, publishing a paper with 1,000 false positive results (or worse, 1,000 detailed investigations of false positive results) would be an enormous waste of time.

There are 2 accepted ways to resolve this issue. One is not to perform 20,000 tests. If we know beforehand that we're only interested in 1 gene, then it's acceptable to design your experiment to examine the one gene (probably not using RNA-seq) so as not to test the other 19,999[^5]. 

The other way is to adjust the $p<0.05$ (usually reported as "adjusted *p*" or *q*-value) threshold to limit the number of expected false positive results. For example, in our RNA-seq experiment above, we could set a stricter $p=\frac{0.05}{20,000}=2.5 \times 10^{-6}$ threshold, so that the cumulative chance of a false positive across *any* of our 20,000 hypotheses is 5%. This is known as *Bonferroni correction*. Another is to set a *q*-value such that no more than *q* of results are expected to be false positives; ie., a threshold of $q<0.1$ indicates that 10% of results would be expected to be false positive. The mathematics of how to do this are beyond scope, but the standard method is *Benjamini-Hochberg FDR correction*. BH correction is standard for differential analysis of RNA-seq and will be used when we test multiple hypotheses in Tutorial 1.3. 

[^1]: A good rule of thumb in software is never to reinvent a solution that already exists[^2]. Using someone else's software is usually easier than writing your own, and it makes your analysis more reproducible. See also [https://xkcd.com/927/].
[^2]: (unless the extant solution is incorrect, not properly maintained, costs money, or implementing a new solution is a graduation requirement)
[^3]: Love MI, Huber W, Anders S. Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome Biol. 2014;15(12):550. doi:10.1186/s13059-014-0550-8. [user guide](https://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html)
[^4]: edgeR 4.0: powerful differential analysis of sequencing data with expanded functionality and improved support for small counts and larger datasets | bioRxiv. Accessed October 18, 2024. https://www.biorxiv.org/content/10.1101/2024.01.21.576131v1 [user guide](https://bioconductor.org/packages/release/bioc/vignettes/edgeR/inst/doc/edgeRUsersGuide.pdf)
[^5]: However, an issue arises when 20,000 independent lab groups each examine a different gene under similar conditions. In that case, the scientific community may still have to read 1,000 publications based on false positive results, even though each lab has followed standard practice using the *p*<0.05 threshold for reporting significant results. This is, in my opinion, a major cause of the current "reproducibility crisis in science". 
