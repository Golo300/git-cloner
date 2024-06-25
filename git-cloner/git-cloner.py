#!/usr/bin/env python
import os
import git
import argparse

def clone_repos(repo_urls, target_directory):
    """
    Klont eine Liste von Git-Repositories in ein Zielverzeichnis.

    :param repo_urls: Liste von GitHub-Repository-URLs
    :param target_directory: Verzeichnis, in das die Repositories geklont werden sollen
    """
    if not os.path.exists(target_directory):
        os.makedirs(target_directory)

    for url in repo_urls:
        try:
            repo_name = url.split('/')[-1].replace('.git', '')
            repo_path = os.path.join(target_directory, repo_name)
            if os.path.exists(repo_path):
                print(f"Repository {repo_name} existiert bereits in {repo_path}.")
            else:
                print(f"Klonen {url} nach {repo_path}...")
                git.Repo.clone_from(url, repo_path)
                print(f"Erfolgreich geklont: {repo_name}")
        except Exception as e:
            print(f"Fehler beim Klonen von {url}: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Klont eine Liste von Git-Repositories in ein Zielverzeichnis.')
    parser.add_argument('repo_urls', nargs='+', help='Liste von GitHub-Repository-URLs')
    parser.add_argument('-d', '--directory', default='./cloned_repos', help='Zielverzeichnis zum Klonen der Repositories (Standard: ./cloned_repos)')

    args = parser.parse_args()
    clone_repos(args.repo_urls, args.directory)

