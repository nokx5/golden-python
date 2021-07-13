"""entrypoint of golden-python"""

import click

from golden.project import Hello


@click.command()
@click.option("--name", default="nokx", help="The person to greet.")
def cli_entrypoint(name):
    """Example script."""
    click.echo(f"Welcome to {name} golden-python project!!")


if __name__ == "__main__":
    cli_entrypoint()
