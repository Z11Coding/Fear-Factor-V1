package backend.util;

import backend.os.HiddenProcess;
#if cpp
import cpp.vm.Gc;
#elseif hl
import hl.Gc;
#elseif java
import java.vm.Gc;
#elseif neko
import neko.vm.Gc;
#end
import openfl.system.System;

using StringTools;

class MemoryUtil {
	public static var disableCount:Int = 0;

	public static function askDisable() {
		disableCount++;
		if (disableCount > 0)
			disable();
		else
			enable();
	}
	public static function askEnable() {
		disableCount--;
		if (disableCount > 0)
			disable();
		else
			enable();
	}

	public static function init() {enable();}

	public static function clearMinor() {
		#if (cpp || java || neko)
		Gc.run(false);	
		#end
	}

	public static function clearMajor() {
		#if cpp
		Gc.run(true);
		Gc.compact();
		System.gc();
		#elseif hl
		Gc.major();
		#elseif (java || neko)
		Gc.run(true);
		#end
	}

	public static function enable() {
		#if (cpp || hl)
		Gc.enable(true);
		#end
	}

	public static function disable() {
		#if (cpp || hl)
		Gc.enable(false);
		#end
	}

	public static function getTotalMem():Float
	{
		#if windows
		return backend.os.Windows.getTotalRam();
		#elseif mac
		return backend.os.Mac.getTotalRam();
		#elseif linux
		return backend.os.Linux.getTotalRam();
		#else
		return 0;
		#end
	}

	public static inline function currentMemUsage() {
		#if cpp
		return Gc.memInfo64(Gc.MEM_INFO_USAGE);
		#elseif sys
		return cast(cast(System.totalMemory, UInt), Float);
		#else
		return 0;
		#end
	}


	public static function getMemType():String {
		#if windows
		var memoryMap:Map<Int, String> = [
			0 => "Unknown",
			1 => "Other",
			2 => "DRAM",
			3 => "Synchronous DRAM",
			4 => "Cache DRAM",
			5 => "EDO",
			6 => "EDRAM",
			7 => "VRAM",
			8 => "SRAM",
			9 => "RAM",
			10 => "ROM",
			11 => "Flash",
			12 => "EEPROM",
			13 => "FEPROM",
			14 => "EPROM",
			15 => "CDRAM",
			16 => "3DRAM",
			17 => "SDRAM",
			18 => "SGRAM",
			19 => "RDRAM",
			20 => "DDR",
			21 => "DDR2",
			22 => "DDR2 FB-DIMM",
			24 => "DDR3",
			25 => "FBD2",
			26 => "DDR4"
		];
		var memoryOutput:Int = -1;

		var process = new HiddenProcess("wmic", ["memorychip", "get", "SMBIOSMemoryType"]);
		if (process.exitCode() == 0) memoryOutput = Std.int(Std.parseFloat(process.stdout.readAll().toString().trim().split("\n")[1]));
		if (memoryOutput != -1) return memoryMap[memoryOutput];
		#elseif mac
		var process = new HiddenProcess("system_profiler", ["SPMemoryDataType"]);
		var reg = ~/Type: (.+)/;
		reg.match(process.stdout.readAll().toString());
		if (process.exitCode() == 0) return reg.matched(1);
		#elseif linux
		var process = new HiddenProcess("sudo", ["dmidecode", "--type", "17"]);
		if (process.exitCode() != 0) return "Unknown";
		var lines = process.stdout.readAll().toString().split("\n");
		for (line in lines) {
			if (line.indexOf("Type:") == 0) {
				return line.substring("Type:".length).trim();
			}
		}
		#end
		return "Unknown";
	}

	private static var _nb:Int = 0;
	private static var _nbD:Int = 0;
	private static var _zombie:Dynamic;

	public static function destroyFlixelZombies() {
		#if cpp
		// Gc.enterGCFreeZone();

		while ((_zombie = Gc.getNextZombie()) != null) {
			_nb++;
			if (_zombie is flixel.util.FlxDestroyUtil.IFlxDestroyable) {
				flixel.util.FlxDestroyUtil.destroy(cast(_zombie, flixel.util.FlxDestroyUtil.IFlxDestroyable));
				_nbD++;
			}
		}
		Sys.println('Zombies: ${_nb}; IFlxDestroyable Zombies: ${_nbD}');

		// Gc.exitGCFreeZone();
		#end
	}
}