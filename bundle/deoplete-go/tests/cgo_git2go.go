package main

/*
#include <git2.h>
*/
import "C"
import (
	"log"
	"os"
	"path/filepath"

	"github.com/libgit2/git2go"
)

func main() {
	repoPath := filepath.Join(os.Getenv("GOPATH"), "src/github.com/libgit2/git2go")
	gitRepo, err := git.OpenRepository(repoPath)
	if err != nil {
		log.Fatal(err)
	}
	commitOid, err := gitRepo.Head()
	if err != nil {

	}
}
