package org.giswater.gui.dialog.options;

import java.awt.Component;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.HashMap;
import java.util.Vector;

import javax.swing.ComboBoxModel;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JPanel;
import javax.swing.JTextField;

import org.giswater.controller.options.DefaultOptionsController;
import org.giswater.util.Utils;


@SuppressWarnings("rawtypes")
public abstract class AbstractOptionsDialog extends JDialog implements ActionListener{

	private static final long serialVersionUID = -7319857198967955753L;
	protected DefaultOptionsController controller;
	public HashMap<String, JComboBox> comboMap;
	public HashMap<String, JTextField> textMap;
	protected JButton btnSave;

	
	public AbstractOptionsDialog() { }
	
	
	public DefaultOptionsController getController(){
		return controller;
	}
	
	
	public void setController(DefaultOptionsController controller) {
		this.controller = controller;
	}	
	
	
	public void setComboModel(JComboBox<String> combo, Vector<String> items) {
		if (items != null){
			ComboBoxModel<String> cbm = new DefaultComboBoxModel<String>(items);
			combo.setModel(cbm);
		}
	}	
	
	
	public void setComboSelectedItem(JComboBox combo, String item){
		combo.setSelectedItem(item);
	}	
	
	
	public void setTextField(JTextField textField, Object value) {
		if (value!=null){
			textField.setText(value.toString());
		}
		else{
			textField.setText("");
		}
	}	
	
	
	protected void createComponentMap() {
		
        comboMap = new HashMap<String, JComboBox>();
        textMap = new HashMap<String, JTextField>();
        Component[] components = getContentPane().getComponents();

        for (int j=0; j<components.length; j++) {
        	if (components[j] instanceof JPanel){
        		JPanel panel = (JPanel) components[j];            
	            Component[] comp = panel.getComponents();        
	            for (int i=0; i < comp.length; i++) {        
	            	if (comp[i] instanceof JComboBox) {         	
	            		comboMap.put(comp[i].getName(), (JComboBox) comp[i]);
	            	}
	            	else if (comp[i] instanceof JTextField) {      
	            		textMap.put(comp[i].getName(), (JTextField) comp[i]);
	            	}
	            }
        	}
        }

	}	
	

	protected void setupListeners() {
		
		this.addWindowListener(new WindowAdapter(){
			public void windowClosing(WindowEvent e){
				int res = Utils.confirmDialog("save_data?");
				if (res == 0){
					controller.saveData();
				}
			}
		});		

		if (btnSave != null){
			btnSave.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent arg0) {
					controller.saveData();
					dispose();
				}
			});		
		}
		
	}
	
	
	@Override
	public void actionPerformed(ActionEvent e) {
		controller.action(e.getActionCommand());
		if (e.getActionCommand().equals("saveData")) {
			dispose();
		}
	}	

	
}