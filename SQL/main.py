from db import connect, post, get
from commands import create_table, drop_table, add_col, drop_col, rename_col
from setup_tables import setup_pokemon, setup_cards
from initialize_expansions import readfile
from initialize_expansion import read_expansion

def init_db():
    setup_pokemon()
    db = setup_cards()
    readfile(db)
    db.commit()
    db.close()

def init_cards():
    db = connect('pokemondb')
    expansion_names = ["Sword and Shield", "Rebel Clash", "Darkness Ablaze", "Champions Path", "Vivid Voltage", "Shining Fates", "Battle Styles", "Chilling Reign", "Evolving Skies", "Fusion Strike", "Brilliant Stars", "Astral Radiance", "Lost Origin", "Silver Tempest", "Paldea Evolved"]
    file_names = ["swsh1", "swsh2", "swsh3", "swsh35", "swsh4", "swsh45", "swsh5", "swsh6", "swsh7", "swsh8", "swsh9", "swsh10", "swsh11", "swsh12", "sv2"]

    for i in range(len(expansion_names)):
        exp = expansion_names[i]
        filename = 'setlists/' + file_names[i] + '.json'
        read_expansion(db, exp, filename)
    db.commit()
    db.close()

def main():
    init_cards()


if __name__ == "__main__":
    main()