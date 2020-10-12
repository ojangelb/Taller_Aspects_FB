package aspects;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import ejemplo.cajero.modelo.Cuenta;

public aspect Transferir {
pointcut guardarTransferencia(): call (private * transferir (..) ); 

	
	before(): guardarTransferencia() {
		System.out.println("Ejecutando : "); 
		Object[] args = thisJoinPoint.getArgs();
		Object cuentaObj = args[0];
		Cuenta cuentaOrg = (Cuenta) cuentaObj;
		Object cuentaDesObj = args[1];
		Cuenta cuentaDest = (Cuenta) cuentaDesObj;
		Object valorOper = args[2];
		String valorOperStr = (String) valorOper;
		String data = "T;"+cuentaOrg.getNumero()+";"+ cuentaOrg.getSaldo() + ";" +cuentaDest.getNumero()+";"+ cuentaDest.getSaldo() + ";"+ valorOperStr;
		auditLogFile(data);
	}
	
	private void auditLogFile(String data) {
		Date date = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");
		String fileName = "./operaciones_" + formatter.format(date) + ".txt";
		System.out.println(fileName);
		File file = new File(fileName);
		FileWriter fw;
		try {
			fw = new FileWriter(file,true);
			BufferedWriter bw = new BufferedWriter(fw);
			bw.write(data);
			bw.newLine();
			bw.close();
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println(e.toString());
		}
	}
}
