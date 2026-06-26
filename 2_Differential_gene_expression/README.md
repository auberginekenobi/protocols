# Session 2 - Differential gene expression

[English](README.md) | [日本語](README.jp.md)

Updated 2026-06-19

## Tutorial 2.0 Installing an R environment from a file

So far we've worked in Python, but for much of bioinformatics, including
differential expression analysis, the best tools are written in the
`R` programming language. The standard tools for differential RNA-seq analysis, `DESeq2` and `edgeR`, are `R`
packages. So for this session we'll switch
languages and set up a dedicated `differential-expression` environment.

Rather than installing each package by hand, we'll install a whole environment
from a file. Back in [Tutorial 0](/0_Setting_up_your_workstation/README.md) we
built an environment one `conda install` command at a time. Here we'll instead
describe the environment in a file and let `conda` build it all at once. This is
more reproducible because anyone with the file can recreate the same environment.

### 2.0.1 The environment file

Open [`differential-expression.yml`](differential-expression.yml) in a text
editor and have a look. It lists:
- a `name` for the environment,
- the `channels` (package repositories) to install from, and
- the `dependencies` — every package we want, grouped by purpose with comments.

You don't need to understand every package yet; we'll meet them as we go.

### 2.0.2 Understanding the install script

An [`install.sh`](install.sh) script is provided to build the environment and
connect it to Jupyter. Bash scripts (ending in `.sh`) are written in the `bash` 
lanugage[^1] used by your terminal. Many, including this one, come with a 'help'
message to explain how to use the script.

In the terminal, run 
```bash install.sh --help``` 
to see the help message.

Next, let's tale a look at the contents of the `install.sh` script. Open `install.sh`
in your favorite text editor. `bash` isn't the easiest language to read, but here's a
high-level explanation of what the script is doing. **Don't run the code below**; it's just an explanation.

1. _Create the environment from the file_:  
   `# conda env create -f differential-expression.yml`  
   This reads the `.yml` file and installs everything listed in it into a new
   environment named `differential-expression`.

2. _(Apple silicon only) Use Intel packages._ Many Bioconductor packages have
   no native build for Apple silicon, so we install the Intel (`osx-64`) versions
   instead, which run fine under emulation. The `--apple-silicon` flag builds the
   environment with `CONDA_SUBDIR=osx-64` and then pins it so future installs use
   `osx-64` too:  
   `# conda run -n differential-expression conda config --env --set subdir osx-64`

3. _Link the environment to Jupyter._ This registers the environment's R
   interpreter as a Jupyter kernel, so you can select it when you open a notebook:  
   `# conda run -n differential-expression Rscript -e "IRkernel::installspec(name = 'differential-expression', displayname = 'differential-expression')"`

### 2.0.3 Run the install script
Now that you understand what the `install.sh` script is doing, let's run it.
From the `2_Differential_gene_expression` directory, run:
```
bash install.sh
```
If you're on a Mac with Apple silicon (M1/M2/M3/...), run it with the
`--apple-silicon` flag instead:
```
bash install.sh --apple-silicon
```

Once the script finishes, move on to lesson 2.1.

## 2.1 Differential expression

The notes and explanations for this exercise are included in the lesson notebook. Run
```
jupyter lab
```
and open [`2-1_differential-expression.ipynb`](2-1_differential-expression.ipynb) and
select the `differential-expression` kernel to get started.

[^1]: Mac OS uses a variant of `bash` called `zsh`. Some commands are different but it's mostly the same.
