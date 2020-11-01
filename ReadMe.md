# Unity3d windows build scripts drafts

These are some scripts here and there I tried in some CI. These are mainly to support a conversation in the following issue:  
https://github.com/webbertakken/unity-builder/issues/82

## [github-actions-windows-jessetg](./github-actions-windows-jessetg)

These are some files shared by JesseTG which could also come handy if you intend to build unity things on a windows runner some day :v:. _Note: building from a windows runner can also build for different platforms such as macOS, Linux, etc._

> [`github-actions-windows-jessetg/index.js`](./github-actions-windows-jessetg/index.js) should work on `macOS` and `Linux` runners. But it's subject to Unity's technical constraints. 👍 This script was mainly written for Jessetg's needs:

* It's more geared towards **self-hosted runners** than the GitHub-hosted environment
* Some arguments are for [Trimmer](https://github.com/sttz/trimmer) support; if you're not using Trimmer, simply don't use those flags

Once TG's project (and its accompanying infrastructure) is more battle-tested he intends to release (a better version of) this script in a more polished package. ❤

## Is this any good?

Yes, kind of, but some problems we may encounter with windows is the following issue:  
https://issuetracker.unity3d.com/issues/command-line-logfile-with-no-parameters-outputs-to-screen-on-os-x-but-not-on-windows

tldr; unity on windows doesn't support _stdout_ properly so we endup with the need to do weird things like these:  
* https://github.com/Unity-CI/unity3d-windows-build-scripts-drafts/blob/master/build-windows-git-bash.sh#L15-L18
* https://github.com/Unity-CI/unity3d-windows-build-scripts-drafts/blob/master/build-windows-git-bash.sh#L38-L39

It should work, but there's definitely place for improvement. You may not be able to get live output log out of your runner (github actions or gitlab-ci) when using a windows machine. If you ever find a solution to this, please let us know! 👀

## Why not a gist?

I could have created a gist for these, but I think I still don't receive notifications out of gists and they're only repos with less features so here are some scripts.

## License

[MIT](LICENSE.md) © [Gabriel Le Breton](https://gableroux.com)
