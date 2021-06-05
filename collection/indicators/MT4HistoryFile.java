import java.io.*;


public class MT4HistoryFile extends MT4File {
	
	private long last_bar_position = 0;
	
	public MT4HistoryFile (String filename) throws FileNotFoundException, IOException {
		super (filename);
	}

	public void createHistoryHeader (String instrument, int timeframe, int digits, String copyright) throws IOException {
		//заполняем заголовок файла истории
		this.FileWriteInteger(400); //version
		this.FileWriteString(copyright, 64); //fixed length field
		this.FileWriteString(instrument, 12); //fixed length field
		this.FileWriteInteger(timeframe); //таймфрейм для которого создается история
		this.FileWriteInteger(digits); //количество цифр после запятой
		this.FileWriteInteger(0); //timesign
		this.FileWriteInteger(0); //last sync
		
		int[] zeroes = new int[13];
		for (int i = 0; i < 13; i++) {
			zeroes[i] = 0;
		}
		this.FileWriteArray(zeroes, 0, 13);
		this.FileFlush();
		
		//сохранить файловый указатель
		last_bar_position = this.FileTell();

		return;
	}
	
	public void historyNewBar (int bar_time, double bar_open, double bar_low, double bar_high, double bar_close, double bar_volume) throws IOException {
		
		this.FileSeek(last_bar_position);
		
		//пишем данные
		this.FileWriteInteger(bar_time);
		this.FileWriteDouble(bar_open);
		this.FileWriteDouble(bar_low);
		this.FileWriteDouble(bar_high);
		this.FileWriteDouble(bar_close);
		this.FileWriteDouble(bar_volume);
		this.FileFlush();
		
		//сохранить файловый указатель
		last_bar_position = this.FileTell();
		
		return;
	}
	
	public void historyUpdateBar (int bar_time, double bar_open, double bar_low, double bar_high, double bar_close, double bar_volume) throws IOException {

		this.FileSeek(last_bar_position);
		
		//пишем данные
		this.FileWriteInteger(bar_time);
		this.FileWriteDouble(bar_open);
		this.FileWriteDouble(bar_low);
		this.FileWriteDouble(bar_high);
		this.FileWriteDouble(bar_close);
		this.FileWriteDouble(bar_volume);
		this.FileFlush();
		
		return;
	}
}

class MT4File {
	RandomAccessFile handle;
	
	public MT4File (String filename) throws FileNotFoundException, IOException {
		handle = new RandomAccessFile (filename, "rw");
	}

	public void FileWriteDouble (double v) throws IOException {
        FileWriteLong(Double.doubleToLongBits(v));
        return;
    }
	
    public void FileWriteLong (long v) throws IOException {
        handle.write((int) (v >>>  0));
        handle.write((int) (v >>>  8));
        handle.write((int) (v >>> 16));
        handle.write((int) (v >>> 24));
        handle.write((int) (v >>> 32));
        handle.write((int) (v >>> 40));
        handle.write((int) (v >>> 48));
        handle.write((int) (v >>> 56));
        return;
    }
	
    public void FileWriteInteger (int v)  throws IOException {
        handle.write(v >>>  0);
        handle.write(v >>>  8);
        handle.write(v >>> 16);
        handle.write(v >>> 24);
        return;
    }
    
    public void FileWriteString (String v, int length) throws IOException {
    	int v_length = v.length();
    	if (length == 0) length = v_length;
    	
    	if (v_length <= length) {
    		for (int i = 0; i < v_length; i++) {
    			handle.write(v.charAt(i));
    		}
    		if (v_length < length) {
        		for (int i = 0; i < length - v_length; i++) {
        			handle.write(0);
        		}
    		}
    	}
    	else 
    		if (v_length > length) {
    			for (int i = 0; i < length; i++) {
    				handle.write(v.charAt(i));
    			}
    		}
    	return;
    }
  
    
    public void FileWriteArray (int[] v, int start, int count) throws IOException {
    	int v_length = v.length;
    	if (count == 0) count = v_length - start;
    	if (count + start > v_length) count = v_length - start;
    	
    	for (int i = 0; i < count; i++) {
    		FileWriteInteger(v[i]);
    	}
    	return;
    }
    
    public long FileTell() throws IOException {
    	return (handle.getFilePointer());
    }
    
    public void FileSeek(long pos) throws IOException {
    	handle.seek(pos);
    }
    
    public void FileFlush() throws IOException {
    	Writer out = new OutputStreamWriter ( new FileOutputStream (handle.getFD()), "UTF-8" );
    	out.flush();
    }
}