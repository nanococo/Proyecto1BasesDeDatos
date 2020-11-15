package com.example.views.forms;

import com.example.services.Services;
import com.example.views.BeneficiaryView;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.combobox.ComboBox;
import com.vaadin.flow.component.datepicker.DatePicker;
import com.vaadin.flow.component.formlayout.FormLayout;
import com.vaadin.flow.component.icon.Icon;
import com.vaadin.flow.component.icon.VaadinIcon;
import com.vaadin.flow.component.notification.Notification;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.textfield.TextField;

import java.time.LocalDate;
import java.util.ArrayList;


public class AddPersonForm extends FormLayout {

    private final TextField id = new TextField("Identificación");
    private final ComboBox<String> idType = new ComboBox<>("Identificación");
    private final DatePicker datePicker = new DatePicker("Birthday");
    private final TextField name = new TextField("Name");
    private final TextField email = new TextField("Email");
    private final TextField phone1 = new TextField("Tel. 1");
    private final TextField phone2 = new TextField("Tel. 2");

    private final Button add = new Button("Add", new Icon(VaadinIcon.FILE_ADD));

    private String date;
    private String idTypeSelected = "";

    private final Services services;
    private BeneficiaryView beneficiaryView;

    public AddPersonForm(Services services) {
        this.services = services;
        setSizeUndefined();
        setVisible(false);

        HorizontalLayout horizontalLayout = new HorizontalLayout(add);
        add(id, idType, datePicker, name, email, phone1, phone2, horizontalLayout);

        configureButton();
        configureComboBox();
        configureDatePicker();
    }

    public void setBeneficiaryView(BeneficiaryView beneficiaryView) {
        this.beneficiaryView = beneficiaryView;
    }

    private void configureComboBox(){
        ArrayList<String> kinshipFromAPI = services.getIdTypes();

        idType.setItems(kinshipFromAPI);
        idType.setValue(kinshipFromAPI.get(0));
        idTypeSelected = kinshipFromAPI.get(0);

        idType.addValueChangeListener(event -> {
            if(event.getValue()!=null){
                idTypeSelected = event.getValue();
            }
        });
    }

    private void configureDatePicker() {
        LocalDate now = LocalDate.now();
        date = now.toString();
        datePicker.setValue(now);

        datePicker.addValueChangeListener(event -> {
            if (event.getValue() != null) {
                date = event.getValue().toString();
            }
        });
    }

    private void configureButton() {
        add.addClickListener(event ->{

            if(id.getValue().chars().allMatch(Character::isDigit)){
                if(phone1.getValue().chars().allMatch( Character::isDigit) && phone2.getValue().chars().allMatch(Character::isDigit)){
                    if(!email.getValue().equals("")){
                        if(!name.getValue().equals("")){
                            if(!idTypeSelected.equals("")){
                                if(services.addPerson(id.getValue(), idTypeSelected, date, name.getValue(), email.getValue(), phone1.getValue(), phone2.getValue())==200){
                                    beneficiaryView.updateDataGrid();
                                    beneficiaryView.checkBeneficiaryAddition();
                                    clearForm();
                                    Notification.show("Added successfully");
                                } else {
                                    Notification.show("No se puede ingresar beneficiario. Revise los campos");
                                }
                            } else {
                                Notification.show("Porfavor seleccione una opción");
                            }
                        }else{
                            Notification.show("Nombre no puede ser vacío");
                        }
                    }else{
                        Notification.show("Email no puede ser vacío");
                    }
                } else {
                    Notification.show("El porcentaje debe ser numérico");
                }
            } else {
                Notification.show("La identificación debe ser numerica");
            }
        });
    }

    public void clearForm(){
        id.clear();
        email.clear();
        name.clear();
        phone1.clear();
        phone2.clear();
    }
}
