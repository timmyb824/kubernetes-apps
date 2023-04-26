git-pull-main:
	git pull gitea main && git pull github main

git-push-main:
	git push gitea main && git push github main

git-push-force:
	git push -f gitea main && git push -f github main