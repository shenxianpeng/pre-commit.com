## -*- coding: utf-8 -*-
<%inherit file="base.mako" />
<div class="row">
    <div class="col-sm-3 hidden-xs pc-sidebar">
        <ul class="nav nav-pills nav-stacked pc-sidenav" data-spy="affix" data-offset-top="400">
            <li class="active"><a href="#intro">Introduction</a></li>
            <li><a href="#install">Installation</a></li>
            <li><a href="#plugins">Adding plugins</a></li>
            <li><a href="#usage">Usage</a></li>
            <li><a href="#new-hooks">Creating new hooks</a></li>
            <li><a href="#advanced">Advanced features</a></li>
            <li><a href="#contributing">Contributing</a></li>
        </ul>
    </div>
    <div class="col-sm-9">
        <div id="intro">
            <div class="page-header">
                <h1>Introduction</h1>
            </div>
            <p>
                At Yelp we rely heavily on pre-commit hooks to find and fix common issues before
                changes are submitted for code review. We run our hooks before every commit to
                automatically point out issues like missing semicolons, whitespace problems, and
                testing statements in code. Automatically fixing these issues before posting
                code reviews allows our code reviewer to pay attention to the architecture of a
                change and not worry about trivial errors.
            </p>
            <p>
                As we created more libraries and projects we recognized that sharing our pre
                commit hooks across projects is painful. We copied and pasted bash scripts
                from project to project and had to manually change the hooks to work for
                different project structures.
            </p>
            <p>
                We believe that you should always use the best industry standard linters. Some
                of the best linters are written in languages that you do not use in your project
                or have installed on your machine. For example scss-lint is a linter for SCSS
                written in Ruby. If you’re writing a project in node you should be able to use
                scss-lint as a pre-commit hook without adding a Gemfile to your project or
                understanding how to get scss-lint installed.
            </p>
            <p>
                We built pre-commit to solve our hook issues. It is a multi-language package
                manager for pre-commit hooks. You specify a list of hooks you want and
                pre-commit manages the installation and execution of any hook written in any
                language before every commit. pre-commit is specifically designed to not require
                root access. If one of your developers doesn’t have node installed but modifies
                a JavaScript file, pre-commit automatically handles downloading and building node
                to run jshint without root.
            </p>
        </div>

        <div id="install">
            <div class="page-header">
                <h1>Installation</h1>
            </div>
            <p>Before you can run hooks, you need to have the pre-commit package manager installed.</p>
            <p>Using pip:</p>
            <pre>pip install pre-commit</pre>
            <p>Non Administrative Installation:</p>
            <pre>curl http://pre-commit.com/install-local.py | python</pre>
            <p>System Level Install:</p>
            <pre>curl https://bootstrap.pypa.io/get-pip.py | sudo python - pre-commit</pre>
            <p>In a Python Project, add the following to your requirements.txt (or requirements-dev.txt):</p>
            <pre>pre-commit</pre>
        </div>

        <div id="plugins">
            <div class="page-header">
                <h1>Adding pre-commit plugins to your project</h1>
            </div>
            <p>Once you have pre-commit installed, adding pre-commit plugins to your project is done with the <code>.pre-commit-config.yaml</code> configuration file.</p>
            <p>Add a file called <code>.pre-commit-config.yaml</code> to the root of your project. The pre-commit config file describes:</p>
            <table class="table table-bordered">
                <tbody>
                    <tr>
                        <td><code>repo</code>, <code>sha</code></td>
                        <td>where to get plugins (git repos).  <code>sha</code> can also be a tag.</td>
                    </tr>
                    <tr>
                        <td><code>id</code></td>
                        <td>What plugins from the repo you want to use.</td>
                    </tr>
                    <tr>
                        <td><code>language_version</code></td>
                        <td>(optional) Override the default language version for the hook. See <a href="#overriding-language-version">Advanced Features: "Overriding Language Version"</a>.</td>
                    </tr>
                    <tr>
                        <td><code>files</code></td>
                        <td>(optional) Override the default pattern for files to run on.</td>
                    </tr>
                    <tr>
                        <td><code>exclude</code></td>
                        <td>(optional) File exclude pattern.</td>
                    </tr>
                    <tr>
                        <td><code>args</code></td>
                        <td>(optional) additional parameters to pass to the hook.</td>
                    </tr>
                </tbody>
            </table>
            <p>For example:</p>
<pre>
-   repo: git://github.com/pre-commit/pre-commit-hooks
    sha: 82344a4055f4e103afdc31e98a46de679fe55385
    hooks:
    -   id: trailing-whitespace
</pre>
            <p>This configuration says to download the pre-commit-hooks project and run its trailing-whitespace hook.</p>
        </div>

        <div id="usage">
            <div class="page-header">
                <h1>Usage</h1>
            </div>
            <p>Run <code>pre-commit install</code> to install pre-commit into your git hooks. pre-commit will now run on every commit. Every time you clone a project using pre-commit running <code>pre-commit install</code> should always be the first thing you do.</p>

            <p>If you want to manually run all pre-commit hooks on a repository, run <code>pre-commit run --all-files</code>. To run individual hooks use <code>pre-commit run &lt;hook_id&gt;</code>.</p>

            <p>The first time pre-commit runs on a file it will automatically download, install, and run the hook. Note that running a hook for the first time may be slow. For example: If the machine does not have node installed, pre-commit will download and build a copy of node.</p>
        </div>

        <div id="new-hooks">
            <div class="page-header">
                <h1>Creating new hooks</h1>
            </div>
            <p>pre-commit currently supports hooks written in JavaScript (node), Python, Ruby and system installed scripts. As long as your git repo is an installable package (gem, npm, pypi, etc.) or exposes an executable, it can be used with pre-commit. Each git repo can support as many languages/hooks as you want.</p>
            <p>
                An executable must satisfy the following things:
                <ul>
                    <li>Returncode of hook must be different between success / failures (Usually 0 for success, nonzero for failure)</li>
                    <li>It must take filenames</li>
                </ul>
            </p>
            <p>A git repo containing pre-commit plugins must contain a hooks.yaml file that tells pre-commit:</p>
            <table class="table table-bordered">
                <tbody>
                    <tr>
                        <td><code>id</code></td>
                        <td>The id of the hook - used in pre-commit-config.yaml</td>
                    </tr>
                    <tr>
                        <td><code>name</code></td>
                        <td>The name of the hook - shown during hook execution</td>
                    </tr>
                    <tr>
                        <td><code>entry</code></td>
                        <td>The entry point - The executable to run</td>
                    </tr>
                    <tr>
                        <td><code>files</code></td>
                        <td>The pattern of files to run on.</td>
                    </tr>
                    <tr>
                        <td><code>language</code></td>
                        <td>The language of the hook - tells pre-commit how to install the hook.</td>
                    </tr>
                    <tr>
                        <td><code>description</code></td>
                        <td>(optional) The description of the hook.</td>
                    </tr>
                    <tr>
                        <td><code>language_version</code></td>
                        <td>(optional) See <a href="#overriding-language-version">Advanced Features: "Overriding Language Version"</a>.</td>
                    </tr>
                    <tr>
                        <td><code>expected_return_value</code></td>
                        <td>(optional) Defaults to 0.</td>
                    </tr>
                </tbody>
            </table>
            <p>For example:</p>
<pre>
-   id: trailing-whitespace
    name: Trim Trailing Whitespace
    description: This hook trims trailing whitespace.
    entry: trailing-whitespace-fixer
    language: python
    files: \.(js|rb|md|py|sh|txt|yaml|yml)$
</pre>
            <h2>Supported languages</h2>
            <ul>
                <li><code>node</code></li>
                <li><code>python</code></li>
                <li><code>ruby</code></li>
                <li><code>pcre</code> - "Perl Compatible Regular Expression" Specify the regex as the <code>entry</code></li>
                <li><code>script</code> - A script existing inside of a repository</li>
                <li><code>system</code> - Executables available at the system level</li>
            </ul>
        </div>

        <div id="advanced">
            <div class="page-header">
                <h1>Advanced features</h1>
            </div>

            <h2>Running in migration mode</h2>
            <p>By default, if you have existing hooks <code>pre-commit install</code> will install in a migration mode which runs both your existing hooks and hooks for pre-commit. To disable this behavior, simply pass <code>-f</code> / <code>--overwrite</code> to the <code>install</code> command. If you decide not to use pre-commit, <code>pre-commit uninstall</code> will restore your hooks to the state prior to installation.</p>

            <h2>Temporarily disabling hooks</h2>
            <p>Not all hooks are perfect so sometimes you may need to skip execution of one or more hooks. pre-commit solves this by querying a <code>SKIP</code> environment variable. The <code>SKIP</code> environment variable is a comma separated list of hook ids. This allows you to skip a single hook instead of <code>--no-verify</code>ing the entire commit.</p>
            <pre>$ SKIP=flake8 git commit -m "foo"</pre>

            <h2>pre-commit during commits</h2>
            <p>Running hooks on unstaged changes can lead to both false-positives and false-negatives during committing. pre-commit only runs on the staged contents of files by temporarily saving the contents of your files at commit time and stashing the unstaged changes while running hooks.</p>

            <h2>pre-commit during merges</h2>
            <p>The biggest gripe we&rsquo;ve had in the past with pre-commit hooks was during merge conflict resolution. When working on very large projects a merge often results in hundreds of committed files. I shouldn&rsquo;t need to run hooks on all of these files that I didn&rsquo;t even touch! This often led to running commit with <code>--no-verify</code> and allowed introduction of real bugs that hooks could have caught. pre-commit solves this by only running hooks on files that conflict or were manually edited during conflict resolution.</p>

            <h2>Passing arguments to hooks</h2>
            <p>Sometimes hooks require arguments to run correctly. You can pass static arguments by specifying the <code>args</code> property in your <code>.pre-commit-config.yaml</code> as follows:</p>
<pre>
-   repo: git://github.com/pre-commit/pre-commit-hooks
    sha: a751eb58f91d8fa70e8b87c9c95777c5a743a932
    hooks:
    -   id: flake8
        args: [--max-line-length=131]
</pre>
            <p>This will pass <code>--max-line-length=131</code> to <code>flake8</code>.</p>

            <h2 id="overriding-language-version">Overriding Language Version</h2>
            <p>Sometimes you only want to run the hooks on a specific version of the language. For each language, they default to using the system installed language (So for example if I&rsquo;m running <code>python2.6</code> and a hook specifies <code>python</code>, pre-commit will run the hook using <code>python2.6</code>). Sometimes you don&rsquo;t want the default system installed version so you can override this on a per-hook basis by setting the <code>language_version</code>.</p>
<pre>
-   repo: git://github.com/pre-commit/mirrors-scss-lint
    sha: d7266131da322d6d76a18d6a3659f21025d9ea11
    hooks:
    -   id: scss-lint
        language_version: 1.9.3-p484
</pre>
            <p>This tells pre-commit to use <code>1.9.3-p484</code> to run the <code>scss-lint</code> hook.</p>
            <p>Valid values for specific languages are listed below:</p>
            <ul>
                <li>
                    python: Whatever system installed python interpreters you have. The value of this argument is passed as the <code>-p</code> to <code>virtualenv</code>.
                </li>
                <li>
                    node: See <a href="https://github.com/ekalinin/nodeenv#advanced">nodeenv</a>.
                </li>
                <li>
                    ruby: See <a href="https://github.com/sstephenson/ruby-build/tree/master/share/ruby-build">ruby-build</a>
                </li>
            </ul>
        </div>

        <div id="contributing">
            <div class="page-header">
                <h1>Contributing</h1>
            </div>
            <p>
                We&rsquo;re looking to grow the project and get more contributors especially to support more languages/versions. We&rsquo;d also like to get the hooks.yaml files added to popular linters without maintaining forks / mirrors.
            </p>
            <p>Feel free to submit Bug Reports, Pull Requests, and Feature Requests.</p>
            <P>When submitting a pull request, please enable travis-ci for your fork.</p>

            <div class="page-header">
                <h1>Contributors</h1>
            </div>
            <ul>
                <li><a href="https://github.com/asottile">Anthony Sottile</a></li>
                <li><a href="https://github.com/struys">Ken Struys</a></li>
                <li><a href="https://github.com/mfnkl">Molly Finkle</a></li>
            </ul>
        </div>
    </div>
</div>
