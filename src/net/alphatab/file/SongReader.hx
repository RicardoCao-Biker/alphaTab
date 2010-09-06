package net.alphatab.file;
import haxe.io.Bytes;
import haxe.io.Input;
import net.alphatab.model.Measure;
import net.alphatab.model.Note;
import net.alphatab.model.Track;
import net.alphatab.model.Voice;
import net.alphatab.platform.BinaryReader;

import net.alphatab.file.guitarpro.Gp3Reader;
import net.alphatab.file.guitarpro.Gp4Reader;
import net.alphatab.file.guitarpro.Gp5Reader;
import net.alphatab.model.Song;
import net.alphatab.model.SongFactory;

/**
 * The Base class for creating file readers. 
 */
class SongReader 
{
	/**
	 * The data source for reading. 
	 */
	public var data:BinaryReader;
	/**
	 * The song factory for creating objects.
	 */
	public var factory:SongFactory;

	/**
	 * Gets a list of the available readers. 
	 */
	public static function availableReaders() : Array<SongReader>
	{
		var d:Array<SongReader> = new Array<SongReader>();
		d.push(new Gp5Reader());
		d.push(new Gp4Reader());
		d.push(new Gp4Reader());
		return d;
	}

	/**
	 * Initializes a new instance of this class.
	 */
	public function new() 
	{
	}
	
	/**
	 * Initializes the reader. 
	 * @param data The data source for reading.
	 * @param factory The song factory for creating objects.
	 */
	public function init(data:BinaryReader, factory:SongFactory) : Void 
	{
		this.data = data;
		this.factory = factory;
	}
	
	/**
	 * Starts the reading of songs.
	 * @return The song which was read from the initialized data source.
	 * @throws FileFormatException Thrown on an error during reading. 
	 */
	public function readSong(): Song
	{
		return factory.newSong();
	}	
	
	/**
	 * Returns the value for a tied note. 
	 */
	public function getTiedNoteValue(stringIndex:Int, track:Track) : Int
	{
		var measureCount:Int = track.measureCount();
        if (measureCount > 0) {
			for (m2 in 0 ... measureCount)
			{
				var m:Int = measureCount - 1 - m2;
				var measure:Measure = track.measures[m];
				for (b2 in 0 ... measure.beatCount())
				{
					var b:Int = measure.beatCount() - 1 - b2;
					var beat = measure.beats[b];
					
					for (v in 0 ... beat.voices.length)
					{
						var voice:Voice = beat.voices[v];
                        if (!voice.isEmpty) {
                            for (n in 0 ... voice.notes.length) {
                                var note:Note = voice.notes[n];
                                if (note.string == stringIndex) {
                                    return note.value;
                                }
                            }
                        }
					}
				}
			}
        }
        return -1;
	}
}