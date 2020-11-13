package com.example.views.forms;

import com.example.services.Services;
import com.example.views.BeneficiaryView;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.combobox.ComboBox;
import com.vaadin.flow.component.formlayout.FormLayout;
import com.vaadin.flow.component.notification.Notification;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.textfield.TextField;

import java.util.ArrayList;

public class AddBeneficiaryForm extends FormLayout {

    private final TextField id = new TextField("Identificacion");
    private final TextField percentage = new TextField("Porcentaje");
    private final ComboBox<String> kinship = new ComboBox<>("Tipo Parentesco");
    private String kinshipSelected = "";
    private final Button save = new Button("Save");
    private final Services service;

    private BeneficiaryView beneficiaryView;

    public AddBeneficiaryForm(Services service) {
        this.service = service;
        setSizeUndefined();
        setVisible(false);
        HorizontalLayout horizontalLayout = new HorizontalLayout(save);
        add(id, percentage, kinship, horizontalLayout);

        configureButton();
        configureComboBox();
    }

    public void setBeneficiaryView(BeneficiaryView beneficiaryView) {
        this.beneficiaryView = beneficiaryView;
    }

    private void configureComboBox(){
        ArrayList<String> kinshipFromAPI = service.getKinship();

        kinship.setItems(kinshipFromAPI);
        kinship.setValue(kinshipFromAPI.get(0));
        kinshipSelected = kinshipFromAPI.get(0);

        kinship.addValueChangeListener(event -> {
            if(event.getValue()!=null){
                kinshipSelected = event.getValue();
            }
        });
    }

    private void configureButton() {
        save.addClickListener(event ->{

            if(id.getValue().chars().allMatch( Character::isDigit)){
                if(percentage.getValue().chars().allMatch( Character::isDigit)){

                    if(!kinshipSelected.equals("")){
                        if(service.addBeneficiary(id.getValue(), percentage.getValue(), kinshipSelected)==200){
                            beneficiaryView.updateDataGrid();
                            beneficiaryView.checkBeneficiaryAddition();
                            clearForm();
                            Notification.show("Added successfully");
                        }
                    } else {
                        kinship.setHelperText("Please choose an option");
                    }

                } else {
                    percentage.setErrorMessage("Percentage must be numeric");
                }
            } else {
                id.setErrorMessage("Id must be numeric");

            }
        });
    }

    public void clearForm(){
        id.clear();
        percentage.clear();
    }


}
