extends Node
class_name Global

const API_ENV_PATH = "res://Configs/env.cfg"
var loopring_api_key = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	# Read Loopring API key
	var env_config = ConfigFile.new()
	var err = env_config.load(API_ENV_PATH)
	if err == ERR_FILE_NOT_FOUND:
		printerr("env.cfg file is missing")
	elif err != OK:
		printerr("Error when attempting to load env.cfg")
	else:
		loopring_api_key = env_config.get_value("API_KEYS", "loopring")

# Loot drop handling
const Hammer = preload("res://Weapons/Hammer.tscn")
const Knife = preload("res://Weapons/Knife.tscn")
const Lighter = preload("res://Weapons/Lighter.tscn")
const Lockpick = preload("res://Weapons/Lockpick.tscn")
enum Item {HAMMER, KNIFE, LIGHTER, LOCKPICK}
const ITEM_SCENES = {
	Item.HAMMER: Hammer,
	Item.KNIFE: Knife,
	Item.LIGHTER: Lighter,
	Item.LOCKPICK: Lockpick
}

func get_item_scene(key: int):
	return ITEM_SCENES.get(key, null)

enum Trait {SLASHING, EXPLOSIVE, SMASH, PIERCING, HACKING, UNLOCK, FIRE}
enum Attack {MELEE, RANGED}

var weapon_data = {
	"Axe-and-Shield": {"Attack": Attack.MELEE, "Traits": [Trait.SLASHING]},
	"Bazooka": {"Attack": Attack.RANGED, "Traits": [Trait.EXPLOSIVE]},
	"Blade": {"Attack": Attack.MELEE, "Traits": [Trait.SLASHING]},
	"Bomb": {"Attack": Attack.RANGED, "Traits": [Trait.EXPLOSIVE]},
	"Bow-and-Arrow": {"Attack": Attack.RANGED, "Traits": [Trait.PIERCING]},
	"Bow": {"Attack": Attack.RANGED, "Traits": [Trait.PIERCING]},
	"Boxing-Gloves": {"Attack": Attack.MELEE, "Traits": [Trait.SMASH]},
	"Chainsaw": {"Attack": Attack.MELEE, "Traits": [Trait.SMASH]},
	"Cowboy-Both-Pistols": {"Attack": Attack.RANGED, "Traits": [Trait.PIERCING]},
	"Cowboy-Left-Pistol": {"Attack": Attack.RANGED, "Traits": [Trait.PIERCING]},
	"Cowboy-Right-Pistol": {"Attack": Attack.RANGED, "Traits": [Trait.PIERCING]},
	"Crowbar": {"Attack": Attack.MELEE, "Traits": [Trait.SMASH, Trait.UNLOCK]},
	"Daggers": {"Attack": Attack.MELEE, "Traits": [Trait.SLASHING]},
	"Dark-Staff": {"Attack": Attack.RANGED, "Traits": [Trait.FIRE]},
	"Dynamite-Stick": {"Attack": Attack.RANGED, "Traits": [Trait.EXPLOSIVE]},
	"Elder-Wand": {"Attack": Attack.RANGED, "Traits": [Trait.PIERCING]},
	"Energy-Sword": {"Attack": Attack.MELEE, "Traits": [Trait.SLASHING]},
	"Flamethrower": {"Attack": Attack.MELEE, "Traits": [Trait.FIRE]},
	"Golden-Blades": {"Attack": Attack.MELEE, "Traits": [Trait.SLASHING]},
	"Golden-Sword": {"Attack": Attack.MELEE, "Traits": [Trait.SLASHING]},
	"Gravity-Gun": {"Attack": Attack.RANGED, "Traits": [Trait.HACKING]},
	"Harpoon": {"Attack": Attack.MELEE, "Traits": [Trait.SLASHING]},
	"Hook": {"Attack": Attack.MELEE, "Traits": [Trait.UNLOCK]},
	"Katana": {"Attack": Attack.MELEE, "Traits": [Trait.SLASHING]},
	"Kunai": {"Attack": Attack.MELEE, "Traits": [Trait.PIERCING]},
	"Laser-Guns": {"Attack": Attack.RANGED, "Traits": [Trait.EXPLOSIVE]},
	"Lightning": {"Attack": Attack.RANGED, "Traits": [Trait.EXPLOSIVE]},
	"Medusas-Head": {"Attack": Attack.MELEE, "Traits": [Trait.SMASH]},
	"Neon-Solid": {"Attack": Attack.MELEE, "Traits": [Trait.HACKING]},
	"Neon-Transparent": {"Attack": Attack.MELEE, "Traits": [Trait.HACKING]},
	"Retro-Futuristic-Rifle": {"Attack": Attack.RANGED, "Traits": [Trait.EXPLOSIVE]},
	"Robot-Claw": {"Attack": Attack.MELEE, "Traits": [Trait.HACKING]},
	"Sai": {"Attack": Attack.MELEE, "Traits": [Trait.SLASHING]},
	"Side-Gun": {"Attack": Attack.RANGED, "Traits": [Trait.PIERCING]},
	"Slingshot": {"Attack": Attack.RANGED, "Traits": [Trait.PIERCING]},
	"Snail-Shell": {"Attack": Attack.RANGED, "Traits": [Trait.EXPLOSIVE]},
	"Sniper": {"Attack": Attack.RANGED, "Traits": [Trait.PIERCING]},
	"Spear-and-Shield": {"Attack": Attack.MELEE, "Traits": [Trait.SLASHING]},
	"Trident": {"Attack": Attack.MELEE, "Traits": [Trait.SLASHING]},
	"Wooden-Staff": {"Attack": Attack.RANGED, "Traits": [Trait.FIRE]},
	"Wrist-Straps": {"Attack": Attack.MELEE, "Traits": [Trait.UNLOCK]},
	"Yatagan": {"Attack": Attack.MELEE, "Traits": [Trait.SLASHING]},
	"Zombie-Hands": {"Attack": Attack.MELEE, "Traits": [Trait.UNLOCK]},
	"Banana": {"Attack": Attack.RANGED, "Traits": [Trait.PIERCING]},
	"Blue-Boxing-Gloves": {"Attack": Attack.MELEE, "Traits": [Trait.SMASH]},
	"BTC-Blade": {"Attack": Attack.MELEE, "Traits": [Trait.SLASHING, Trait.FIRE]},
	"Red-Boxing-Gloves": {"Attack": Attack.MELEE, "Traits": [Trait.SMASH]},
	"STX-Blaster": {"Attack": Attack.RANGED, "Traits": [Trait.EXPLOSIVE]},
	"Surrender-Flag": {"Attack": Attack.MELEE, "Traits": [Trait.SMASH]},
	
	# For testing purposes
	"Admin-Tool": {"Attack": Attack.MELEE, "Traits": [Trait.SLASHING, Trait.EXPLOSIVE, Trait.SMASH, Trait.PIERCING, Trait.HACKING, Trait.UNLOCK, Trait.FIRE]},
}
