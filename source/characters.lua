-- Character data mapping
local characterData = {
    {id=1, name="Farmer", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=2, name="Warrior", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=3, name="Mage", rarity=2, faction="normal", texturepath="assets/placeholder.png"},
    {id=4, name="Archer", rarity=2, faction="normal", texturepath="assets/placeholder.png"},
    {id=5, name="Rogue", rarity=2, faction="normal", texturepath="assets/placeholder.png"},
    {id=6, name="Paladin", rarity=3, faction="holy", texturepath="assets/placeholder.png"},
    {id=7, name="Necromancer", rarity=4, faction="dark", texturepath="assets/placeholder.png"},
    {id=8, name="Berserker", rarity=2, faction="wild", texturepath="assets/placeholder.png"},
    {id=9, name="Cleric", rarity=2, faction="holy", texturepath="assets/placeholder.png"},
    {id=10, name="Assassin", rarity=3, faction="shadow", texturepath="assets/placeholder.png"},
    {id=11, name="Druid", rarity=3, faction="nature", texturepath="assets/placeholder.png"},
    {id=12, name="Knight", rarity=2, faction="normal", texturepath="assets/placeholder.png"},
    {id=13, name="Ranger", rarity=2, faction="nature", texturepath="assets/placeholder.png"},
    {id=14, name="Sorcerer", rarity=4, faction="arcane", texturepath="assets/placeholder.png"},
    {id=15, name="Barbarian", rarity=1, faction="wild", texturepath="assets/placeholder.png"},
    {id=16, name="Monk", rarity=3, faction="holy", texturepath="assets/placeholder.png"},
    {id=17, name="Warlock", rarity=5, faction="dark", texturepath="assets/placeholder.png"},
    {id=18, name="Bard", rarity=2, faction="normal", texturepath="assets/placeholder.png"},
    {id=19, name="Witch", rarity=4, faction="dark", texturepath="assets/placeholder.png"},
    {id=20, name="Samurai", rarity=5, faction="honor", texturepath="assets/placeholder.png"},
    {id=21, name="Pirate", rarity=3, faction="chaos", texturepath="assets/placeholder.png"},
    {id=22, name="Ninja", rarity=4, faction="shadow", texturepath="assets/placeholder.png"},
    {id=23, name="Alchemist", rarity=4, faction="arcane", texturepath="assets/placeholder.png"},
    {id=24, name="Gladiator", rarity=3, faction="arena", texturepath="assets/placeholder.png"},
    {id=25, name="Shaman", rarity=4, faction="spirit", texturepath="assets/placeholder.png"},
    {id=26, name="Crusader", rarity=5, faction="holy", texturepath="assets/placeholder.png"},
    {id=27, name="Elementalist", rarity=6, faction="elemental", texturepath="assets/placeholder.png"},
    {id=28, name="Mercenary", rarity=1, faction="neutral", texturepath="assets/placeholder.png"},
    {id=29, name="Vampire", rarity=6, faction="undead", texturepath="assets/placeholder.png"},
    {id=30, name="Angel", rarity=7, faction="divine", texturepath="assets/placeholder.png"},
    {id=31, name="Demon", rarity=7, faction="infernal", texturepath="assets/placeholder.png"},
    {id=32, name="Dragon", rarity=8, faction="ancient", texturepath="assets/placeholder.png"},
    {id=33, name="Phoenix", rarity=8, faction="celestial", texturepath="assets/placeholder.png"},
    {id=34, name="Lich", rarity=9, faction="undead", texturepath="assets/placeholder.png"},
    {id=35, name="Titan", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=36, name="Bandit", rarity=1, faction="chaos", texturepath="assets/placeholder.png"},
    {id=37, name="Scout", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=38, name="Healer", rarity=2, faction="holy", texturepath="assets/placeholder.png"},
    {id=39, name="Spellsword", rarity=3, faction="arcane", texturepath="assets/placeholder.png"},
    {id=40, name="Trickster", rarity=3, faction="chaos", texturepath="assets/placeholder.png"},
    {id=41, name="Guardian", rarity=3, faction="nature", texturepath="assets/placeholder.png"},
    {id=42, name="Summoner", rarity=5, faction="arcane", texturepath="assets/placeholder.png"},
    {id=43, name="Templar", rarity=5, faction="holy", texturepath="assets/placeholder.png"},
    {id=44, name="Artificer", rarity=4, faction="tech", texturepath="assets/placeholder.png"},
    {id=45, name="Warden", rarity=3, faction="nature", texturepath="assets/placeholder.png"},
    {id=46, name="Peasant", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=47, name="Villager", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=48, name="Militia", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=49, name="Recruit", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=50, name="Laborer", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=51, name="Apprentice", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=52, name="Squire", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=53, name="Acolyte", rarity=1, faction="holy", texturepath="assets/placeholder.png"},
    {id=54, name="Initiate", rarity=1, faction="arcane", texturepath="assets/placeholder.png"},
    {id=55, name="Novice", rarity=1, faction="nature", texturepath="assets/placeholder.png"},
    {id=56, name="Thief", rarity=1, faction="shadow", texturepath="assets/placeholder.png"},
    {id=57, name="Cutthroat", rarity=1, faction="chaos", texturepath="assets/placeholder.png"},
    {id=58, name="Sellsword", rarity=1, faction="neutral", texturepath="assets/placeholder.png"},
    {id=59, name="Footman", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=60, name="Spearman", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=61, name="Crossbowman", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=62, name="Sentry", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=63, name="Watchman", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=64, name="Tracker", rarity=1, faction="nature", texturepath="assets/placeholder.png"},
    {id=65, name="Forager", rarity=1, faction="nature", texturepath="assets/placeholder.png"},
    {id=66, name="Herbalist", rarity=1, faction="nature", texturepath="assets/placeholder.png"},
    {id=67, name="Cultist", rarity=1, faction="dark", texturepath="assets/placeholder.png"},
    {id=68, name="Zealot", rarity=1, faction="holy", texturepath="assets/placeholder.png"},
    {id=69, name="Pilgrim", rarity=1, faction="holy", texturepath="assets/placeholder.png"},
    {id=70, name="Wanderer", rarity=1, faction="neutral", texturepath="assets/placeholder.png"},
    {id=71, name="Drifter", rarity=1, faction="neutral", texturepath="assets/placeholder.png"},
    {id=72, name="Outlaw", rarity=1, faction="chaos", texturepath="assets/placeholder.png"},
    {id=73, name="Brigand", rarity=1, faction="chaos", texturepath="assets/placeholder.png"},
    {id=74, name="Raider", rarity=1, faction="wild", texturepath="assets/placeholder.png"},
    {id=75, name="Savage", rarity=1, faction="wild", texturepath="assets/placeholder.png"},
    {id=76, name="Tribesman", rarity=1, faction="wild", texturepath="assets/placeholder.png"},
    {id=77, name="Hunter", rarity=1, faction="nature", texturepath="assets/placeholder.png"},
    {id=78, name="Trapper", rarity=1, faction="nature", texturepath="assets/placeholder.png"},
    {id=79, name="Woodsman", rarity=1, faction="nature", texturepath="assets/placeholder.png"},
    {id=80, name="Fisherman", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=81, name="Sailor", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=82, name="Deckhand", rarity=1, faction="chaos", texturepath="assets/placeholder.png"},
    {id=83, name="Smuggler", rarity=1, faction="shadow", texturepath="assets/placeholder.png"},
    {id=84, name="Fence", rarity=1, faction="shadow", texturepath="assets/placeholder.png"},
    {id=85, name="Pickpocket", rarity=1, faction="shadow", texturepath="assets/placeholder.png"},
    {id=86, name="Burglar", rarity=1, faction="shadow", texturepath="assets/placeholder.png"},
    {id=87, name="Lookout", rarity=1, faction="chaos", texturepath="assets/placeholder.png"},
    {id=88, name="Messenger", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=89, name="Courier", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=90, name="Scribe", rarity=1, faction="arcane", texturepath="assets/placeholder.png"},
    {id=91, name="Scholar", rarity=2, faction="arcane", texturepath="assets/placeholder.png"},
    {id=92, name="Sage", rarity=2, faction="arcane", texturepath="assets/placeholder.png"},
    {id=93, name="Lorekeeper", rarity=2, faction="arcane", texturepath="assets/placeholder.png"},
    {id=94, name="Chronicler", rarity=2, faction="arcane", texturepath="assets/placeholder.png"},
    {id=95, name="Librarian", rarity=2, faction="arcane", texturepath="assets/placeholder.png"},
    {id=96, name="Archivist", rarity=2, faction="arcane", texturepath="assets/placeholder.png"},
    {id=97, name="Enchanter", rarity=2, faction="arcane", texturepath="assets/placeholder.png"},
    {id=98, name="Illusionist", rarity=2, faction="arcane", texturepath="assets/placeholder.png"},
    {id=99, name="Conjurer", rarity=2, faction="arcane", texturepath="assets/placeholder.png"},
    {id=100, name="Diviner", rarity=2, faction="arcane", texturepath="assets/placeholder.png"},
    {id=101, name="Oracle", rarity=3, faction="divine", texturepath="assets/placeholder.png"},
    {id=102, name="Prophet", rarity=3, faction="divine", texturepath="assets/placeholder.png"},
    {id=103, name="Seer", rarity=3, faction="divine", texturepath="assets/placeholder.png"},
    {id=104, name="Mystic", rarity=3, faction="spirit", texturepath="assets/placeholder.png"},
    {id=105, name="Medium", rarity=3, faction="spirit", texturepath="assets/placeholder.png"},
    {id=106, name="Channeler", rarity=3, faction="spirit", texturepath="assets/placeholder.png"},
    {id=107, name="Exorcist", rarity=3, faction="holy", texturepath="assets/placeholder.png"},
    {id=108, name="Inquisitor", rarity=3, faction="holy", texturepath="assets/placeholder.png"},
    {id=109, name="Chaplain", rarity=2, faction="holy", texturepath="assets/placeholder.png"},
    {id=110, name="Deacon", rarity=2, faction="holy", texturepath="assets/placeholder.png"},
    {id=111, name="Bishop", rarity=3, faction="holy", texturepath="assets/placeholder.png"},
    {id=112, name="Cardinal", rarity=4, faction="holy", texturepath="assets/placeholder.png"},
    {id=113, name="Archbishop", rarity=4, faction="holy", texturepath="assets/placeholder.png"},
    {id=114, name="Pope", rarity=5, faction="holy", texturepath="assets/placeholder.png"},
    {id=115, name="Saint", rarity=6, faction="divine", texturepath="assets/placeholder.png"},
    {id=116, name="Martyr", rarity=5, faction="divine", texturepath="assets/placeholder.png"},
    {id=117, name="Confessor", rarity=4, faction="holy", texturepath="assets/placeholder.png"},
    {id=118, name="Missionary", rarity=3, faction="holy", texturepath="assets/placeholder.png"},
    {id=119, name="Evangelist", rarity=3, faction="holy", texturepath="assets/placeholder.png"},
    {id=120, name="Preacher", rarity=2, faction="holy", texturepath="assets/placeholder.png"},
    {id=121, name="Priest", rarity=2, faction="holy", texturepath="assets/placeholder.png"},
    {id=122, name="Vicar", rarity=2, faction="holy", texturepath="assets/placeholder.png"},
    {id=123, name="Abbot", rarity=3, faction="holy", texturepath="assets/placeholder.png"},
    {id=124, name="Prior", rarity=3, faction="holy", texturepath="assets/placeholder.png"},
    {id=125, name="Friar", rarity=2, faction="holy", texturepath="assets/placeholder.png"},
    {id=126, name="Brother", rarity=2, faction="holy", texturepath="assets/placeholder.png"},
    {id=127, name="Sister", rarity=2, faction="holy", texturepath="assets/placeholder.png"},
    {id=128, name="Nun", rarity=2, faction="holy", texturepath="assets/placeholder.png"},
    {id=129, name="Mother Superior", rarity=3, faction="holy", texturepath="assets/placeholder.png"},
    {id=130, name="Abbess", rarity=3, faction="holy", texturepath="assets/placeholder.png"},
    {id=131, name="Heretic", rarity=2, faction="dark", texturepath="assets/placeholder.png"},
    {id=132, name="Apostate", rarity=3, faction="dark", texturepath="assets/placeholder.png"},
    {id=133, name="Blasphemer", rarity=3, faction="dark", texturepath="assets/placeholder.png"},
    {id=134, name="Defiler", rarity=4, faction="dark", texturepath="assets/placeholder.png"},
    {id=135, name="Corruptor", rarity=4, faction="dark", texturepath="assets/placeholder.png"},
    {id=136, name="Desecrator", rarity=5, faction="dark", texturepath="assets/placeholder.png"},
    {id=137, name="Demonologist", rarity=5, faction="infernal", texturepath="assets/placeholder.png"},
    {id=138, name="Diabolist", rarity=6, faction="infernal", texturepath="assets/placeholder.png"},
    {id=139, name="Fiend", rarity=4, faction="infernal", texturepath="assets/placeholder.png"},
    {id=140, name="Imp", rarity=2, faction="infernal", texturepath="assets/placeholder.png"},
    {id=141, name="Succubus", rarity=5, faction="infernal", texturepath="assets/placeholder.png"},
    {id=142, name="Incubus", rarity=5, faction="infernal", texturepath="assets/placeholder.png"},
    {id=143, name="Balrog", rarity=7, faction="infernal", texturepath="assets/placeholder.png"},
    {id=144, name="Archfiend", rarity=8, faction="infernal", texturepath="assets/placeholder.png"},
    {id=145, name="Devil", rarity=6, faction="infernal", texturepath="assets/placeholder.png"},
    {id=146, name="Daemon", rarity=6, faction="infernal", texturepath="assets/placeholder.png"},
    {id=147, name="Hellhound", rarity=4, faction="infernal", texturepath="assets/placeholder.png"},
    {id=148, name="Pit Lord", rarity=7, faction="infernal", texturepath="assets/placeholder.png"},
    {id=149, name="Demon Prince", rarity=8, faction="infernal", texturepath="assets/placeholder.png"},
    {id=150, name="Fallen Angel", rarity=7, faction="infernal", texturepath="assets/placeholder.png"},
    {id=151, name="Seraph", rarity=8, faction="divine", texturepath="assets/placeholder.png"},
    {id=152, name="Cherub", rarity=7, faction="divine", texturepath="assets/placeholder.png"},
    {id=153, name="Archangel", rarity=8, faction="divine", texturepath="assets/placeholder.png"},
    {id=154, name="Guardian Angel", rarity=6, faction="divine", texturepath="assets/placeholder.png"},
    {id=155, name="Herald", rarity=5, faction="divine", texturepath="assets/placeholder.png"},
    {id=156, name="Messenger Angel", rarity=4, faction="divine", texturepath="assets/placeholder.png"},
    {id=157, name="Virtue", rarity=6, faction="divine", texturepath="assets/placeholder.png"},
    {id=158, name="Power", rarity=7, faction="divine", texturepath="assets/placeholder.png"},
    {id=159, name="Dominion", rarity=7, faction="divine", texturepath="assets/placeholder.png"},
    {id=160, name="Throne", rarity=8, faction="divine", texturepath="assets/placeholder.png"},
    {id=161, name="Ophanim", rarity=9, faction="celestial", texturepath="assets/placeholder.png"},
    {id=162, name="Seraphim", rarity=9, faction="celestial", texturepath="assets/placeholder.png"},
    {id=163, name="Cherubim", rarity=9, faction="celestial", texturepath="assets/placeholder.png"},
    {id=164, name="Avatar", rarity=8, faction="divine", texturepath="assets/placeholder.png"},
    {id=165, name="Deity", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=166, name="God", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=167, name="Goddess", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=168, name="Creator", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=169, name="Destroyer", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=170, name="Primarch", rarity=9, faction="primordial", texturepath="assets/placeholder.png"},
    {id=171, name="Elder", rarity=8, faction="ancient", texturepath="assets/placeholder.png"},
    {id=172, name="Ancient One", rarity=9, faction="ancient", texturepath="assets/placeholder.png"},
    {id=173, name="Old God", rarity=10, faction="ancient", texturepath="assets/placeholder.png"},
    {id=174, name="Cosmic Horror", rarity=9, faction="ancient", texturepath="assets/placeholder.png"},
    {id=175, name="Eldritch Being", rarity=8, faction="ancient", texturepath="assets/placeholder.png"},
    {id=176, name="Aberration", rarity=7, faction="ancient", texturepath="assets/placeholder.png"},
    {id=177, name="Monstrosity", rarity=6, faction="ancient", texturepath="assets/placeholder.png"},
    {id=178, name="Behemoth", rarity=7, faction="ancient", texturepath="assets/placeholder.png"},
    {id=179, name="Leviathan", rarity=8, faction="ancient", texturepath="assets/placeholder.png"},
    {id=180, name="Kraken", rarity=7, faction="ancient", texturepath="assets/placeholder.png"},
    {id=181, name="Hydra", rarity=6, faction="ancient", texturepath="assets/placeholder.png"},
    {id=182, name="Chimera", rarity=5, faction="ancient", texturepath="assets/placeholder.png"},
    {id=183, name="Manticore", rarity=4, faction="ancient", texturepath="assets/placeholder.png"},
    {id=184, name="Sphinx", rarity=5, faction="ancient", texturepath="assets/placeholder.png"},
    {id=185, name="Griffin", rarity=4, faction="ancient", texturepath="assets/placeholder.png"},
    {id=186, name="Pegasus", rarity=4, faction="celestial", texturepath="assets/placeholder.png"},
    {id=187, name="Unicorn", rarity=5, faction="celestial", texturepath="assets/placeholder.png"},
    {id=188, name="Alicorn", rarity=6, faction="celestial", texturepath="assets/placeholder.png"},
    {id=189, name="Qilin", rarity=6, faction="celestial", texturepath="assets/placeholder.png"},
    {id=190, name="Kirin", rarity=6, faction="celestial", texturepath="assets/placeholder.png"},
    {id=191, name="Thunderbird", rarity=7, faction="elemental", texturepath="assets/placeholder.png"},
    {id=192, name="Roc", rarity=6, faction="elemental", texturepath="assets/placeholder.png"},
    {id=193, name="Simurgh", rarity=7, faction="elemental", texturepath="assets/placeholder.png"},
    {id=194, name="Garuda", rarity=7, faction="elemental", texturepath="assets/placeholder.png"},
    {id=195, name="Quetzalcoatl", rarity=8, faction="elemental", texturepath="assets/placeholder.png"},
    {id=196, name="Bahamut", rarity=9, faction="elemental", texturepath="assets/placeholder.png"},
    {id=197, name="Tiamat", rarity=9, faction="elemental", texturepath="assets/placeholder.png"},
    {id=198, name="Jormungandr", rarity=8, faction="elemental", texturepath="assets/placeholder.png"},
    {id=199, name="Ouroboros", rarity=8, faction="elemental", texturepath="assets/placeholder.png"},
    {id=200, name="Salamander", rarity=3, faction="elemental", texturepath="assets/placeholder.png"},
    {id=201, name="Ifrit", rarity=4, faction="elemental", texturepath="assets/placeholder.png"},
    {id=202, name="Efreet", rarity=5, faction="elemental", texturepath="assets/placeholder.png"},
    {id=203, name="Djinn", rarity=4, faction="elemental", texturepath="assets/placeholder.png"},
    {id=204, name="Genie", rarity=5, faction="elemental", texturepath="assets/placeholder.png"},
    {id=205, name="Marid", rarity=6, faction="elemental", texturepath="assets/placeholder.png"},
    {id=206, name="Sylph", rarity=3, faction="elemental", texturepath="assets/placeholder.png"},
    {id=207, name="Undine", rarity=3, faction="elemental", texturepath="assets/placeholder.png"},
    {id=208, name="Gnome", rarity=2, faction="elemental", texturepath="assets/placeholder.png"},
    {id=209, name="Dryad", rarity=3, faction="nature", texturepath="assets/placeholder.png"},
    {id=210, name="Naiad", rarity=3, faction="nature", texturepath="assets/placeholder.png"},
    {id=211, name="Hamadryad", rarity=4, faction="nature", texturepath="assets/placeholder.png"},
    {id=212, name="Nymph", rarity=3, faction="nature", texturepath="assets/placeholder.png"},
    {id=213, name="Faerie", rarity=2, faction="nature", texturepath="assets/placeholder.png"},
    {id=214, name="Pixie", rarity=2, faction="nature", texturepath="assets/placeholder.png"},
    {id=215, name="Sprite", rarity=2, faction="nature", texturepath="assets/placeholder.png"},
    {id=216, name="Brownie", rarity=2, faction="nature", texturepath="assets/placeholder.png"},
    {id=217, name="Leprechaun", rarity=3, faction="nature", texturepath="assets/placeholder.png"},
    {id=218, name="Satyr", rarity=3, faction="nature", texturepath="assets/placeholder.png"},
    {id=219, name="Centaur", rarity=4, faction="nature", texturepath="assets/placeholder.png"},
    {id=220, name="Minotaur", rarity=4, faction="nature", texturepath="assets/placeholder.png"},
    {id=221, name="Cyclops", rarity=5, faction="ancient", texturepath="assets/placeholder.png"},
    {id=222, name="Giant", rarity=5, faction="ancient", texturepath="assets/placeholder.png"},
    {id=223, name="Ogre", rarity=3, faction="wild", texturepath="assets/placeholder.png"},
    {id=224, name="Troll", rarity=4, faction="wild", texturepath="assets/placeholder.png"},
    {id=225, name="Orc", rarity=2, faction="wild", texturepath="assets/placeholder.png"},
    {id=226, name="Goblin", rarity=1, faction="wild", texturepath="assets/placeholder.png"},
    {id=227, name="Hobgoblin", rarity=2, faction="wild", texturepath="assets/placeholder.png"},
    {id=228, name="Bugbear", rarity=3, faction="wild", texturepath="assets/placeholder.png"},
    {id=229, name="Gnoll", rarity=2, faction="wild", texturepath="assets/placeholder.png"},
    {id=230, name="Kobold", rarity=1, faction="wild", texturepath="assets/placeholder.png"},
    {id=231, name="Lizardman", rarity=2, faction="wild", texturepath="assets/placeholder.png"},
    {id=232, name="Troglodyte", rarity=2, faction="wild", texturepath="assets/placeholder.png"},
    {id=233, name="Draconian", rarity=4, faction="ancient", texturepath="assets/placeholder.png"},
    {id=234, name="Dragonborn", rarity=3, faction="ancient", texturepath="assets/placeholder.png"},
    {id=235, name="Wyrmling", rarity=3, faction="ancient", texturepath="assets/placeholder.png"},
    {id=236, name="Drake", rarity=4, faction="ancient", texturepath="assets/placeholder.png"},
    {id=237, name="Wyvern", rarity=5, faction="ancient", texturepath="assets/placeholder.png"},
    {id=238, name="Wyrm", rarity=7, faction="ancient", texturepath="assets/placeholder.png"},
    {id=239, name="Great Wyrm", rarity=8, faction="ancient", texturepath="assets/placeholder.png"},
    {id=240, name="Ancient Dragon", rarity=9, faction="ancient", texturepath="assets/placeholder.png"},
    {id=241, name="Primordial Dragon", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=242, name="Skeleton", rarity=1, faction="undead", texturepath="assets/placeholder.png"},
    {id=243, name="Zombie", rarity=1, faction="undead", texturepath="assets/placeholder.png"},
    {id=244, name="Ghoul", rarity=2, faction="undead", texturepath="assets/placeholder.png"},
    {id=245, name="Wight", rarity=3, faction="undead", texturepath="assets/placeholder.png"},
    {id=246, name="Wraith", rarity=4, faction="undead", texturepath="assets/placeholder.png"},
    {id=247, name="Specter", rarity=4, faction="undead", texturepath="assets/placeholder.png"},
    {id=248, name="Banshee", rarity=5, faction="undead", texturepath="assets/placeholder.png"},
    {id=249, name="Ghost", rarity=3, faction="undead", texturepath="assets/placeholder.png"},
    {id=250, name="Phantom", rarity=4, faction="undead", texturepath="assets/placeholder.png"},
    {id=251, name="Poltergeist", rarity=3, faction="undead", texturepath="assets/placeholder.png"},
    {id=252, name="Revenant", rarity=5, faction="undead", texturepath="assets/placeholder.png"},
    {id=253, name="Death Knight", rarity=6, faction="undead", texturepath="assets/placeholder.png"},
    {id=254, name="Bone Dragon", rarity=7, faction="undead", texturepath="assets/placeholder.png"},
    {id=255, name="Dracolich", rarity=8, faction="undead", texturepath="assets/placeholder.png"},
    {id=256, name="Archlich", rarity=9, faction="undead", texturepath="assets/placeholder.png"},
    {id=257, name="Demilich", rarity=8, faction="undead", texturepath="assets/placeholder.png"},
    {id=258, name="Mummy", rarity=4, faction="undead", texturepath="assets/placeholder.png"},
    {id=259, name="Mummy Lord", rarity=6, faction="undead", texturepath="assets/placeholder.png"},
    {id=260, name="Pharaoh", rarity=7, faction="undead", texturepath="assets/placeholder.png"},
    {id=261, name="Assassin Lord", rarity=6, faction="shadow", texturepath="assets/placeholder.png"},
    {id=262, name="Shadow Master", rarity=7, faction="shadow", texturepath="assets/placeholder.png"},
    {id=263, name="Shadowdancer", rarity=5, faction="shadow", texturepath="assets/placeholder.png"},
    {id=264, name="Nightblade", rarity=4, faction="shadow", texturepath="assets/placeholder.png"},
    {id=265, name="Darkblade", rarity=5, faction="shadow", texturepath="assets/placeholder.png"},
    {id=266, name="Shadowknight", rarity=6, faction="shadow", texturepath="assets/placeholder.png"},
    {id=267, name="Shade", rarity=3, faction="shadow", texturepath="assets/placeholder.png"},
    {id=268, name="Shadow", rarity=2, faction="shadow", texturepath="assets/placeholder.png"},
    {id=269, name="Umbral", rarity=4, faction="shadow", texturepath="assets/placeholder.png"},
    {id=270, name="Void Walker", rarity=7, faction="shadow", texturepath="assets/placeholder.png"},
    {id=271, name="Void Lord", rarity=8, faction="shadow", texturepath="assets/placeholder.png"},
    {id=272, name="Void Master", rarity=9, faction="shadow", texturepath="assets/placeholder.png"},
    {id=273, name="Void God", rarity=10, faction="shadow", texturepath="assets/placeholder.png"},
    {id=274, name="Chaos Lord", rarity=7, faction="chaos", texturepath="assets/placeholder.png"},
    {id=275, name="Chaos Knight", rarity=5, faction="chaos", texturepath="assets/placeholder.png"},
    {id=276, name="Chaos Warrior", rarity=4, faction="chaos", texturepath="assets/placeholder.png"},
    {id=277, name="Chaos Spawn", rarity=3, faction="chaos", texturepath="assets/placeholder.png"},
    {id=278, name="Mutant", rarity=2, faction="chaos", texturepath="assets/placeholder.png"},
    {id=279, name="Aberrant", rarity=4, faction="chaos", texturepath="assets/placeholder.png"},
    {id=280, name="Twisted One", rarity=5, faction="chaos", texturepath="assets/placeholder.png"},
    {id=281, name="Madman", rarity=3, faction="chaos", texturepath="assets/placeholder.png"},
    {id=282, name="Lunatic", rarity=2, faction="chaos", texturepath="assets/placeholder.png"},
    {id=283, name="Anarchist", rarity=3, faction="chaos", texturepath="assets/placeholder.png"},
    {id=284, name="Rebel", rarity=2, faction="chaos", texturepath="assets/placeholder.png"},
    {id=285, name="Revolutionary", rarity=3, faction="chaos", texturepath="assets/placeholder.png"},
    {id=286, name="Insurgent", rarity=3, faction="chaos", texturepath="assets/placeholder.png"},
    {id=287, name="Terrorist", rarity=4, faction="chaos", texturepath="assets/placeholder.png"},
    {id=288, name="Saboteur", rarity=3, faction="chaos", texturepath="assets/placeholder.png"},
    {id=289, name="Spy", rarity=3, faction="shadow", texturepath="assets/placeholder.png"},
    {id=290, name="Agent", rarity=4, faction="shadow", texturepath="assets/placeholder.png"},
    {id=291, name="Operative", rarity=4, faction="shadow", texturepath="assets/placeholder.png"},
    {id=292, name="Infiltrator", rarity=5, faction="shadow", texturepath="assets/placeholder.png"},
    {id=293, name="Double Agent", rarity=6, faction="shadow", texturepath="assets/placeholder.png"},
    {id=294, name="Spymaster", rarity=7, faction="shadow", texturepath="assets/placeholder.png"},
    {id=295, name="Technician", rarity=2, faction="tech", texturepath="assets/placeholder.png"},
    {id=296, name="Engineer", rarity=3, faction="tech", texturepath="assets/placeholder.png"},
    {id=297, name="Inventor", rarity=4, faction="tech", texturepath="assets/placeholder.png"},
    {id=298, name="Scientist", rarity=4, faction="tech", texturepath="assets/placeholder.png"},
    {id=299, name="Researcher", rarity=3, faction="tech", texturepath="assets/placeholder.png"},
    {id=300, name="Professor", rarity=4, faction="tech", texturepath="assets/placeholder.png"},
    {id=301, name="Genius", rarity=5, faction="tech", texturepath="assets/placeholder.png"},
    {id=302, name="Mad Scientist", rarity=6, faction="tech", texturepath="assets/placeholder.png"},
    {id=303, name="Cyborg", rarity=5, faction="tech", texturepath="assets/placeholder.png"},
    {id=304, name="Android", rarity=6, faction="tech", texturepath="assets/placeholder.png"},
    {id=305, name="Robot", rarity=4, faction="tech", texturepath="assets/placeholder.png"},
    {id=306, name="Automaton", rarity=5, faction="tech", texturepath="assets/placeholder.png"},
    {id=307, name="Golem", rarity=4, faction="arcane", texturepath="assets/placeholder.png"},
    {id=308, name="Construct", rarity=3, faction="arcane", texturepath="assets/placeholder.png"},
    {id=309, name="Homunculus", rarity=3, faction="arcane", texturepath="assets/placeholder.png"},
    {id=310, name="Familiar", rarity=2, faction="arcane", texturepath="assets/placeholder.png"},
    {id=311, name="Imp Familiar", rarity=3, faction="arcane", texturepath="assets/placeholder.png"},
    {id=312, name="Elemental", rarity=4, faction="elemental", texturepath="assets/placeholder.png"},
    {id=313, name="Fire Elemental", rarity=4, faction="elemental", texturepath="assets/placeholder.png"},
    {id=314, name="Water Elemental", rarity=4, faction="elemental", texturepath="assets/placeholder.png"},
    {id=315, name="Earth Elemental", rarity=4, faction="elemental", texturepath="assets/placeholder.png"},
    {id=316, name="Air Elemental", rarity=4, faction="elemental", texturepath="assets/placeholder.png"},
    {id=317, name="Lightning Elemental", rarity=5, faction="elemental", texturepath="assets/placeholder.png"},
    {id=318, name="Ice Elemental", rarity=5, faction="elemental", texturepath="assets/placeholder.png"},
    {id=319, name="Magma Elemental", rarity=6, faction="elemental", texturepath="assets/placeholder.png"},
    {id=320, name="Storm Elemental", rarity=6, faction="elemental", texturepath="assets/placeholder.png"},
    {id=321, name="Void Elemental", rarity=7, faction="elemental", texturepath="assets/placeholder.png"},
    {id=322, name="Primordial Elemental", rarity=8, faction="elemental", texturepath="assets/placeholder.png"},
    {id=323, name="Elemental Lord", rarity=9, faction="elemental", texturepath="assets/placeholder.png"},
    {id=324, name="Elemental God", rarity=10, faction="elemental", texturepath="assets/placeholder.png"},
    {id=325, name="Spirit", rarity=2, faction="spirit", texturepath="assets/placeholder.png"},
    {id=326, name="Ancestral Spirit", rarity=3, faction="spirit", texturepath="assets/placeholder.png"},
    {id=327, name="Guardian Spirit", rarity=4, faction="spirit", texturepath="assets/placeholder.png"},
    {id=328, name="Nature Spirit", rarity=3, faction="spirit", texturepath="assets/placeholder.png"},
    {id=329, name="Forest Spirit", rarity=4, faction="spirit", texturepath="assets/placeholder.png"},
    {id=330, name="Mountain Spirit", rarity=4, faction="spirit", texturepath="assets/placeholder.png"},
    {id=331, name="River Spirit", rarity=3, faction="spirit", texturepath="assets/placeholder.png"},
    {id=332, name="Wind Spirit", rarity=3, faction="spirit", texturepath="assets/placeholder.png"},
    {id=333, name="Fire Spirit", rarity=3, faction="spirit", texturepath="assets/placeholder.png"},
    {id=334, name="Earth Spirit", rarity=3, faction="spirit", texturepath="assets/placeholder.png"},
    {id=335, name="Spirit Guide", rarity=5, faction="spirit", texturepath="assets/placeholder.png"},
    {id=336, name="Totem Spirit", rarity=4, faction="spirit", texturepath="assets/placeholder.png"},
    {id=337, name="Animal Spirit", rarity=3, faction="spirit", texturepath="assets/placeholder.png"},
    {id=338, name="Wolf Spirit", rarity=4, faction="spirit", texturepath="assets/placeholder.png"},
    {id=339, name="Bear Spirit", rarity=4, faction="spirit", texturepath="assets/placeholder.png"},
    {id=340, name="Eagle Spirit", rarity=4, faction="spirit", texturepath="assets/placeholder.png"},
    {id=341, name="Serpent Spirit", rarity=5, faction="spirit", texturepath="assets/placeholder.png"},
    {id=342, name="Dragon Spirit", rarity=7, faction="spirit", texturepath="assets/placeholder.png"},
    {id=343, name="Phoenix Spirit", rarity=8, faction="spirit", texturepath="assets/placeholder.png"},
    {id=344, name="Great Spirit", rarity=9, faction="spirit", texturepath="assets/placeholder.png"},
    {id=345, name="World Spirit", rarity=10, faction="spirit", texturepath="assets/placeholder.png"},
    {id=346, name="Gladiator Champion", rarity=5, faction="arena", texturepath="assets/placeholder.png"},
    {id=347, name="Arena Master", rarity=6, faction="arena", texturepath="assets/placeholder.png"},
    {id=348, name="Pit Fighter", rarity=3, faction="arena", texturepath="assets/placeholder.png"},
    {id=349, name="Brawler", rarity=2, faction="arena", texturepath="assets/placeholder.png"},
    {id=350, name="Boxer", rarity=2, faction="arena", texturepath="assets/placeholder.png"},
    {id=351, name="Wrestler", rarity=2, faction="arena", texturepath="assets/placeholder.png"},
    {id=352, name="Duelist", rarity=3, faction="arena", texturepath="assets/placeholder.png"},
    {id=353, name="Fencer", rarity=3, faction="arena", texturepath="assets/placeholder.png"},
    {id=354, name="Swordmaster", rarity=4, faction="arena", texturepath="assets/placeholder.png"},
    {id=355, name="Blademaster", rarity=5, faction="arena", texturepath="assets/placeholder.png"},
    {id=356, name="Weaponmaster", rarity=6, faction="arena", texturepath="assets/placeholder.png"},
    {id=357, name="Combat Master", rarity=7, faction="arena", texturepath="assets/placeholder.png"},
    {id=358, name="War God", rarity=9, faction="arena", texturepath="assets/placeholder.png"},
    {id=359, name="Battle Lord", rarity=8, faction="arena", texturepath="assets/placeholder.png"},
    {id=360, name="Warlord", rarity=6, faction="arena", texturepath="assets/placeholder.png"},
    {id=361, name="General", rarity=5, faction="normal", texturepath="assets/placeholder.png"},
    {id=362, name="Commander", rarity=4, faction="normal", texturepath="assets/placeholder.png"},
    {id=363, name="Captain", rarity=3, faction="normal", texturepath="assets/placeholder.png"},
    {id=364, name="Lieutenant", rarity=2, faction="normal", texturepath="assets/placeholder.png"},
    {id=365, name="Sergeant", rarity=2, faction="normal", texturepath="assets/placeholder.png"},
    {id=366, name="Corporal", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=367, name="Private", rarity=1, faction="normal", texturepath="assets/placeholder.png"},
    {id=368, name="Veteran", rarity=3, faction="normal", texturepath="assets/placeholder.png"},
    {id=369, name="Elite", rarity=4, faction="normal", texturepath="assets/placeholder.png"},
    {id=370, name="Champion", rarity=5, faction="normal", texturepath="assets/placeholder.png"},
    {id=371, name="Hero", rarity=6, faction="normal", texturepath="assets/placeholder.png"},
    {id=372, name="Legend", rarity=7, faction="normal", texturepath="assets/placeholder.png"},
    {id=373, name="Myth", rarity=8, faction="normal", texturepath="assets/placeholder.png"},
    {id=374, name="Immortal", rarity=9, faction="normal", texturepath="assets/placeholder.png"},
    {id=375, name="Eternal", rarity=10, faction="normal", texturepath="assets/placeholder.png"},
    {id=376, name="Honor Guard", rarity=4, faction="honor", texturepath="assets/placeholder.png"},
    {id=377, name="Royal Guard", rarity=5, faction="honor", texturepath="assets/placeholder.png"},
    {id=378, name="Imperial Guard", rarity=6, faction="honor", texturepath="assets/placeholder.png"},
    {id=379, name="Praetorian", rarity=7, faction="honor", texturepath="assets/placeholder.png"},
    {id=380, name="Centurion", rarity=4, faction="honor", texturepath="assets/placeholder.png"},
    {id=381, name="Legionnaire", rarity=3, faction="honor", texturepath="assets/placeholder.png"},
    {id=382, name="Tribune", rarity=5, faction="honor", texturepath="assets/placeholder.png"},
    {id=383, name="Consul", rarity=6, faction="honor", texturepath="assets/placeholder.png"},
    {id=384, name="Emperor", rarity=8, faction="honor", texturepath="assets/placeholder.png"},
    {id=385, name="Shogun", rarity=7, faction="honor", texturepath="assets/placeholder.png"},
    {id=386, name="Daimyo", rarity=6, faction="honor", texturepath="assets/placeholder.png"},
    {id=387, name="Ronin", rarity=4, faction="honor", texturepath="assets/placeholder.png"},
    {id=388, name="Ashigaru", rarity=2, faction="honor", texturepath="assets/placeholder.png"},
    {id=389, name="Hatamoto", rarity=5, faction="honor", texturepath="assets/placeholder.png"},
    {id=390, name="Bushido Master", rarity=7, faction="honor", texturepath="assets/placeholder.png"},
    {id=391, name="Sword Saint", rarity=8, faction="honor", texturepath="assets/placeholder.png"},
    {id=392, name="Living Sword", rarity=9, faction="honor", texturepath="assets/placeholder.png"},
    {id=393, name="Blade God", rarity=10, faction="honor", texturepath="assets/placeholder.png"},
    {id=394, name="Neutral Agent", rarity=2, faction="neutral", texturepath="assets/placeholder.png"},
    {id=395, name="Freelancer", rarity=2, faction="neutral", texturepath="assets/placeholder.png"},
    {id=396, name="Contractor", rarity=3, faction="neutral", texturepath="assets/placeholder.png"},
    {id=397, name="Broker", rarity=4, faction="neutral", texturepath="assets/placeholder.png"},
    {id=398, name="Mediator", rarity=4, faction="neutral", texturepath="assets/placeholder.png"},
    {id=399, name="Arbitrator", rarity=5, faction="neutral", texturepath="assets/placeholder.png"},
    {id=400, name="Peacekeeper", rarity=5, faction="neutral", texturepath="assets/placeholder.png"},
    {id=401, name="Diplomat", rarity=4, faction="neutral", texturepath="assets/placeholder.png"},
    {id=402, name="Ambassador", rarity=5, faction="neutral", texturepath="assets/placeholder.png"},
    {id=403, name="Envoy", rarity=3, faction="neutral", texturepath="assets/placeholder.png"},
    {id=404, name="Emissary", rarity=4, faction="neutral", texturepath="assets/placeholder.png"},
    {id=405, name="Herald of Peace", rarity=6, faction="neutral", texturepath="assets/placeholder.png"},
    {id=406, name="Balance Keeper", rarity=7, faction="neutral", texturepath="assets/placeholder.png"},
    {id=407, name="Equilibrium", rarity=8, faction="neutral", texturepath="assets/placeholder.png"},
    {id=408, name="Cosmic Balance", rarity=9, faction="neutral", texturepath="assets/placeholder.png"},
    {id=409, name="Universal Harmony", rarity=10, faction="neutral", texturepath="assets/placeholder.png"},
    {id=410, name="Stargazer", rarity=3, faction="celestial", texturepath="assets/placeholder.png"},
    {id=411, name="Astronomer", rarity=4, faction="celestial", texturepath="assets/placeholder.png"},
    {id=412, name="Astrologer", rarity=4, faction="celestial", texturepath="assets/placeholder.png"},
    {id=413, name="Star Reader", rarity=5, faction="celestial", texturepath="assets/placeholder.png"},
    {id=414, name="Constellation", rarity=6, faction="celestial", texturepath="assets/placeholder.png"},
    {id=415, name="Nebula", rarity=7, faction="celestial", texturepath="assets/placeholder.png"},
    {id=416, name="Supernova", rarity=8, faction="celestial", texturepath="assets/placeholder.png"},
    {id=417, name="Quasar", rarity=9, faction="celestial", texturepath="assets/placeholder.png"},
    {id=418, name="Black Hole", rarity=9, faction="celestial", texturepath="assets/placeholder.png"},
    {id=419, name="Galactic Core", rarity=10, faction="celestial", texturepath="assets/placeholder.png"},
    {id=420, name="Universe", rarity=10, faction="celestial", texturepath="assets/placeholder.png"},
    {id=421, name="Multiverse", rarity=10, faction="celestial", texturepath="assets/placeholder.png"},
    {id=422, name="Reality", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=423, name="Existence", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=424, name="Nothingness", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=425, name="Everything", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=426, name="Alpha", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=427, name="Omega", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=428, name="Beginning", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=429, name="End", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=430, name="Eternity", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=431, name="Infinity", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=432, name="Concept", rarity=9, faction="primordial", texturepath="assets/placeholder.png"},
    {id=433, name="Idea", rarity=8, faction="primordial", texturepath="assets/placeholder.png"},
    {id=434, name="Thought", rarity=7, faction="primordial", texturepath="assets/placeholder.png"},
    {id=435, name="Dream", rarity=6, faction="primordial", texturepath="assets/placeholder.png"},
    {id=436, name="Nightmare", rarity=6, faction="primordial", texturepath="assets/placeholder.png"},
    {id=437, name="Vision", rarity=5, faction="primordial", texturepath="assets/placeholder.png"},
    {id=438, name="Prophecy", rarity=5, faction="primordial", texturepath="assets/placeholder.png"},
    {id=439, name="Destiny", rarity=7, faction="primordial", texturepath="assets/placeholder.png"},
    {id=440, name="Fate", rarity=8, faction="primordial", texturepath="assets/placeholder.png"},
    {id=441, name="Chance", rarity=6, faction="primordial", texturepath="assets/placeholder.png"},
    {id=442, name="Luck", rarity=5, faction="primordial", texturepath="assets/placeholder.png"},
    {id=443, name="Fortune", rarity=6, faction="primordial", texturepath="assets/placeholder.png"},
    {id=444, name="Misfortune", rarity=6, faction="primordial", texturepath="assets/placeholder.png"},
    {id=445, name="Calamity", rarity=7, faction="primordial", texturepath="assets/placeholder.png"},
    {id=446, name="Disaster", rarity=6, faction="primordial", texturepath="assets/placeholder.png"},
    {id=447, name="Catastrophe", rarity=8, faction="primordial", texturepath="assets/placeholder.png"},
    {id=448, name="Apocalypse", rarity=9, faction="primordial", texturepath="assets/placeholder.png"},
    {id=449, name="Armageddon", rarity=9, faction="primordial", texturepath="assets/placeholder.png"},
    {id=450, name="Ragnarok", rarity=9, faction="primordial", texturepath="assets/placeholder.png"},
    {id=451, name="Judgment Day", rarity=9, faction="primordial", texturepath="assets/placeholder.png"},
    {id=452, name="Final Hour", rarity=8, faction="primordial", texturepath="assets/placeholder.png"},
    {id=453, name="Last Stand", rarity=7, faction="primordial", texturepath="assets/placeholder.png"},
    {id=454, name="Ultimate Sacrifice", rarity=8, faction="primordial", texturepath="assets/placeholder.png"},
    {id=455, name="Perfect Victory", rarity=8, faction="primordial", texturepath="assets/placeholder.png"},
    {id=456, name="Absolute Power", rarity=9, faction="primordial", texturepath="assets/placeholder.png"},
    {id=457, name="Supreme Authority", rarity=9, faction="primordial", texturepath="assets/placeholder.png"},
    {id=458, name="Divine Right", rarity=8, faction="primordial", texturepath="assets/placeholder.png"},
    {id=459, name="Cosmic Will", rarity=9, faction="primordial", texturepath="assets/placeholder.png"},
    {id=460, name="Universal Law", rarity=9, faction="primordial", texturepath="assets/placeholder.png"},
    {id=461, name="Natural Order", rarity=8, faction="primordial", texturepath="assets/placeholder.png"},
    {id=462, name="Chaos Theory", rarity=8, faction="primordial", texturepath="assets/placeholder.png"},
    {id=463, name="Quantum Uncertainty", rarity=9, faction="primordial", texturepath="assets/placeholder.png"},
    {id=464, name="Probability Wave", rarity=8, faction="primordial", texturepath="assets/placeholder.png"},
    {id=465, name="Schrödinger's Cat", rarity=9, faction="primordial", texturepath="assets/placeholder.png"},
    {id=466, name="Observer Effect", rarity=8, faction="primordial", texturepath="assets/placeholder.png"},
    {id=467, name="Butterfly Effect", rarity=7, faction="primordial", texturepath="assets/placeholder.png"},
    {id=468, name="Domino Effect", rarity=6, faction="primordial", texturepath="assets/placeholder.png"},
    {id=469, name="Chain Reaction", rarity=6, faction="primordial", texturepath="assets/placeholder.png"},
    {id=470, name="Ripple Effect", rarity=5, faction="primordial", texturepath="assets/placeholder.png"},
    {id=471, name="Echo", rarity=4, faction="primordial", texturepath="assets/placeholder.png"},
    {id=472, name="Reflection", rarity=4, faction="primordial", texturepath="assets/placeholder.png"},
    {id=473, name="Mirror", rarity=3, faction="primordial", texturepath="assets/placeholder.png"},
    {id=474, name="Shadow", rarity=3, faction="primordial", texturepath="assets/placeholder.png"},
    {id=475, name="Light", rarity=4, faction="primordial", texturepath="assets/placeholder.png"},
    {id=476, name="Darkness", rarity=4, faction="primordial", texturepath="assets/placeholder.png"},
    {id=477, name="Dawn", rarity=5, faction="primordial", texturepath="assets/placeholder.png"},
    {id=478, name="Dusk", rarity=5, faction="primordial", texturepath="assets/placeholder.png"},
    {id=479, name="Noon", rarity=4, faction="primordial", texturepath="assets/placeholder.png"},
    {id=480, name="Midnight", rarity=5, faction="primordial", texturepath="assets/placeholder.png"},
    {id=481, name="Eclipse", rarity=6, faction="primordial", texturepath="assets/placeholder.png"},
    {id=482, name="Solstice", rarity=6, faction="primordial", texturepath="assets/placeholder.png"},
    {id=483, name="Equinox", rarity=6, faction="primordial", texturepath="assets/placeholder.png"},
    {id=484, name="Season", rarity=5, faction="primordial", texturepath="assets/placeholder.png"},
    {id=485, name="Year", rarity=4, faction="primordial", texturepath="assets/placeholder.png"},
    {id=486, name="Decade", rarity=5, faction="primordial", texturepath="assets/placeholder.png"},
    {id=487, name="Century", rarity=6, faction="primordial", texturepath="assets/placeholder.png"},
    {id=488, name="Millennium", rarity=7, faction="primordial", texturepath="assets/placeholder.png"},
    {id=489, name="Eon", rarity=8, faction="primordial", texturepath="assets/placeholder.png"},
    {id=490, name="Era", rarity=7, faction="primordial", texturepath="assets/placeholder.png"},
    {id=491, name="Age", rarity=6, faction="primordial", texturepath="assets/placeholder.png"},
    {id=492, name="Epoch", rarity=7, faction="primordial", texturepath="assets/placeholder.png"},
    {id=493, name="Moment", rarity=3, faction="primordial", texturepath="assets/placeholder.png"},
    {id=494, name="Instant", rarity=4, faction="primordial", texturepath="assets/placeholder.png"},
    {id=495, name="Eternity's End", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=496, name="Time's Beginning", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=497, name="Space's Edge", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=498, name="Reality's Core", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=499, name="Truth Itself", rarity=10, faction="primordial", texturepath="assets/placeholder.png"},
    {id=500, name="The One Above All", rarity=10, faction="primordial", texturepath="assets/placeholder.png"}
}

-- Create character from data
local function createCharacter(data)
    return {
        id = data.id or 0,
        name = data.name,
        rarity = data.rarity,
        faction = data.faction,
        texture = data.texturepath or "assets/placeholder.png"
    }
end

-- Gacha draw function
local function drawCharacter()
    local rarityRoll = love.math.random(1, 1000000)
    local gamestate = require('source.gamestate')
    
    local selectedRarity
    if rarityRoll <= 400000 then
        selectedRarity = 1  -- Common (40%)
    elseif rarityRoll <= 650000 then
        selectedRarity = 2  -- Uncommon (25%)
    elseif rarityRoll <= 800000 then
        selectedRarity = 3  -- Rare (15%)
    elseif rarityRoll <= 900000 then
        selectedRarity = 4  -- Epic (10%)
    elseif rarityRoll <= 960000 then
        selectedRarity = 5  -- Legendary (6%)
    elseif rarityRoll <= 990000 then
        selectedRarity = 6  -- Mythic (3%)
    elseif rarityRoll <= 998000 then
        selectedRarity = 7  -- Ancient (0.8%)
    elseif rarityRoll <= 999500 then
        selectedRarity = 8  -- Divine (0.15%)
    elseif rarityRoll <= 999900 then
        selectedRarity = 9  -- Cosmic (0.04%)
    else
        selectedRarity = 10 -- Transcendent (0.01%)
    end
    
    local charactersOfRarity = {}
    for _, char in ipairs(characterData) do
        if char.rarity == selectedRarity then
            table.insert(charactersOfRarity, char)
        end
    end
    
    if #charactersOfRarity > 0 then
        local chosen = charactersOfRarity[love.math.random(1, #charactersOfRarity)]
        if not gamestate.data.characters then gamestate.data.characters = {} end
        gamestate.data.characters[tostring(chosen.id)] = (gamestate.data.characters[tostring(chosen.id)] or 0) + 1
        return createCharacter(chosen)
    end
    
    return nil
end

-- Get character info by ID
local function getCharacterInfo(characterId)
    for _, char in ipairs(characterData) do
        if char.id == characterId then
            return char
        end
    end
    return nil
end

-- Get characters sorted by rarity then alphabetically
local function getSortedCharacters()
    local sorted = {}
    
    for _, char in ipairs(characterData) do
        table.insert(sorted, char)
    end
    
    table.sort(sorted, function(a, b)
        if a.rarity == b.rarity then
            return a.name < b.name
        end
        return a.rarity < b.rarity
    end)
    
    return sorted
end

-- Get rarity name from number
local function getRarityName(rarity)
    local rarityNames = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Ascendant", "Superior", "Ultimate", "Deific"}
    return rarityNames[rarity] or "Unknown"
end



-- Get character texture based on ownership
local function getCharacterTexture(characterId)
    local gamestate = require('source.gamestate')
    if gamestate.data.characters and gamestate.data.characters[tostring(characterId)] and gamestate.data.characters[tostring(characterId)] > 0 then
        return "assets/placeholder.png"  -- Use placeholder for discovered characters
    end
    return "assets/mystery_character-1.png (13).png"  -- Use actual mystery character file
end

-- Get collection stats
local function getCollectionStats()
    local gamestate = require('source.gamestate')
    local stats = {
        totalOwned = 0,
        totalPossible = #characterData,
        totalCopies = 0,
        rarityOwned = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        rarityPossible = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    }
    
    -- Count possible characters by rarity
    for _, char in ipairs(characterData) do
        stats.rarityPossible[char.rarity] = stats.rarityPossible[char.rarity] + 1
    end
    
    -- Count owned characters (unique only)
    if gamestate.data.characters then
        local seenCharacters = {}
        for charId, count in pairs(gamestate.data.characters) do
            if count and count > 0 then
                local numericId = type(charId) == "string" and tonumber(charId) or charId
                local char = getCharacterInfo(numericId)
                if char and not seenCharacters[numericId] then
                    seenCharacters[numericId] = true
                    stats.totalOwned = stats.totalOwned + 1
                    stats.rarityOwned[char.rarity] = stats.rarityOwned[char.rarity] + 1
                end
                if char then
                    stats.totalCopies = stats.totalCopies + count
                end
            end
        end
    end
    
    return stats
end

return {
    drawCharacter = drawCharacter,
    getCharacterTexture = getCharacterTexture,
    getCharacterInfo = getCharacterInfo,
    getSortedCharacters = getSortedCharacters,
    getRarityName = getRarityName,
    getCollectionStats = getCollectionStats
}