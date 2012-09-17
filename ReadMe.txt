git as deployment tool

What was the problem?

My company has a large php website. Changes developed for the web site were released as a small set of files packed up manually. Because the company had a tradition of making changes directly on production server, before deploying changes to production, a copy of production php files were compared with SCM contents. And the developer needed to incorporate the difference with the release files.
This deploy process was manual and quite error-prone. There was no version control of the web site at all because SCM has no control over production.

Options

We have considered full tar ball deployment and git patch file deployment. Full tar ball method is bad because changes done directly on production will be lost. Recover them might be costly. git patch file requires good knowledge of git and good understanding of the code being released. Unix admins don’t have either of them.
My colleague came across an idea to use git as deployment tool. Google lead us to Using Git for Deployment. By setup php working dir as git repository, we can deploy changes quick and safe. Unix admins doesn’t need any knowledge of either git or the code base. We can pack the commands for deployment in shell scripts.
The other difficult thing to handle is changes done directly on production server.

Solution

Fortunately git has a utility called stash. With stash, I managed to handle changes done directly on server.
We have two deployment scripts written up, one for overnight update, the other for manually initiated release. There are two main steps for the release:
Check for local changes
Pull in difference from a branch
Check for local changes is done by running a stash command and check if any stash is created. Pull in difference is a straight pull from a certain branch in a central repo.
Overnight and manual release have different logic in determining whether to pull. If local changes are found, overnight update will report it, re-apply the stashed changes back and not pull any difference; where as manual release will report it but pull the difference. If no local changes are found, difference will be pulled in.
Also we installed a pre-commit hook to stop commit on server.
