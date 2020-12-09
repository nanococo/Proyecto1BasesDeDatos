package com.example.views.forms;

import com.example.pojos.ObjectiveAccount;
import com.example.services.Services;
import com.example.views.ObjectiveAccountsView;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.datepicker.DatePicker;
import com.vaadin.flow.component.formlayout.FormLayout;
import com.vaadin.flow.component.icon.Icon;
import com.vaadin.flow.component.icon.VaadinIcon;
import com.vaadin.flow.component.notification.Notification;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.textfield.TextField;

import java.time.LocalDate;

public class EditObjectiveAccountForm extends FormLayout {

    private final TextField amount = new TextField("Amount");
    private final TextField description = new TextField("Description");
    private final DatePicker datePickerStart = new DatePicker("Inicio");
    private final DatePicker datePickerEnd = new DatePicker("Fin");
    private final TextField dayOfPayments = new TextField("Dia de Rebajos");
    private final Button edit = new Button("Add", new Icon(VaadinIcon.PENCIL));
    private final Services service;

    private int id;
    private String startDate;
    private String endDate;
    private final LocalDate now = LocalDate.now();
    private final ObjectiveAccountsView objectiveAccountsView;


    public EditObjectiveAccountForm(Services services, ObjectiveAccountsView objectiveAccountsView) {
        this.objectiveAccountsView = objectiveAccountsView;
        this.service = services;
        setSizeUndefined();
        setVisible(false);

        HorizontalLayout horizontalLayout = new HorizontalLayout(edit);
        add(amount, description, datePickerStart, datePickerEnd, dayOfPayments, horizontalLayout);

        configureButton();
        configureDatePickerStart();
        configureDatePickerEnd();
    }

    private void configureDatePickerStart() {
        startDate = now.toString();
        datePickerStart.setValue(now);

        datePickerStart.addValueChangeListener(event -> {
            if (event.getValue() != null) {
                startDate = event.getValue().toString();
            }
        });
    }

    private void configureDatePickerEnd(){
        endDate = now.toString();
        datePickerEnd.setValue(now);

        datePickerEnd.addValueChangeListener(event -> {
            if (event.getValue() != null) {
                endDate = event.getValue().toString();
            }
        });
    }

    public void setObjectiveAccount(ObjectiveAccount objectiveAccount){
        if(objectiveAccount!=null){
            id = objectiveAccount.getId();
            amount.setValue(objectiveAccount.getAmount());
            description.setValue(objectiveAccount.getDescription());
            datePickerStart.setValue(LocalDate.parse(objectiveAccount.getStartDate()));
            datePickerEnd.setValue(LocalDate.parse(objectiveAccount.getEndDate()));
            dayOfPayments.setValue(objectiveAccount.getSaveDate());
        } else {
            id = -1;
            clearForm();
        }
    }


    private void configureButton() {
        edit.addClickListener(event ->{
            if(amount.getValue().matches("[+-]?([0-9]*[.])?[0-9]+")){
                if(!description.getValue().equals("")){
                    if(!startDate.equals("") && !endDate.equals("")){
                        if(dayOfPayments.getValue().chars().allMatch(Character::isDigit) && Integer.parseInt(dayOfPayments.getValue())<31){
                            if(service.updateObjectiveAccount(id, amount.getValue(), description.getValue(), startDate, endDate, dayOfPayments.getValue())==200){
                                objectiveAccountsView.updateDataGrid();
                                clearForm();
                                Notification.show("Updated successfully");
                            } else {
                                Notification.show("No se puede ingresar beneficiario. Revise los campos");
                            }
                        } else{
                            Notification.show("Dia de rebajo debe ser numerico y menor a 31");
                        }
                    }else{
                        Notification.show("Seleccione fecha de inicio y fin");
                    }
                }else{
                    Notification.show("Descripcion no puede ser vacío");
                }
            } else {
                Notification.show("La cantidad debe ser numerica");
            }
        });
    }

    public void clearForm(){
        amount.clear();
        description.clear();
        dayOfPayments.clear();
        datePickerStart.setValue(now);
        datePickerEnd.setValue(now);
    }


}
