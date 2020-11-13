package com.example.views.forms;

import com.example.pojos.Beneficiary;
import com.example.services.Services;
import com.example.views.BeneficiaryView;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.combobox.ComboBox;
import com.vaadin.flow.component.datepicker.DatePicker;
import com.vaadin.flow.component.formlayout.FormLayout;
import com.vaadin.flow.component.notification.Notification;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.textfield.TextField;
import org.springframework.lang.Nullable;

import java.time.LocalDate;
import java.util.ArrayList;

public class EditBeneficiaryForm extends FormLayout {
    private final TextField id = new TextField("Identificación");
    private final TextField name = new TextField("Nombre");
    private final TextField email = new TextField("Email");
    private final DatePicker datePicker = new DatePicker();
    private final ComboBox<String> kinship = new ComboBox<>("Tipo Parentesco");
    private final TextField percentage = new TextField("Porcentaje");
    private final TextField phone1 = new TextField("Tel. 1");
    private final TextField phone2 = new TextField("Tel. 2");
    private final Button update = new Button("Update");

    private String date;

    private final ArrayList<String> kinshipFromAPI;

    private final Services service;
    private BeneficiaryView beneficiaryView;

    @Nullable
    private Beneficiary beneficiary;

    public EditBeneficiaryForm(Services service){
        this.service = service;
        setSizeUndefined();
        setVisible(false);
        configureUpdate();
        configureDatePicker();


        kinshipFromAPI = service.getKinship();
        kinship.setItems(kinshipFromAPI);
        kinship.setAllowCustomValue(false);
        HorizontalLayout horizontalLayout = new HorizontalLayout(update);
        add(id, name, email, datePicker, kinship, percentage, phone1, phone2, horizontalLayout);
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

    public void setBeneficiaryView(BeneficiaryView beneficiaryView) {
        this.beneficiaryView = beneficiaryView;
    }

    public void setBeneficiary(Beneficiary beneficiary) {
        kinship.setItems(kinshipFromAPI);
        if(beneficiary!=null){
            this.beneficiary = beneficiary;
            id.setValue(String.valueOf(beneficiary.getPhysicalIdValue()));
            name.setValue(String.valueOf(beneficiary.getName()));
            email.setValue(String.valueOf(beneficiary.getEmail()));
            kinship.setValue(kinshipFromAPI.get(beneficiary.getKinshipId()-1));
            percentage.setValue(String.valueOf(beneficiary.getPercentage()));
            phone2.setValue(String.valueOf(beneficiary.getNum2()));
            phone1.setValue(String.valueOf(beneficiary.getNum1()));
        } else {
            id.clear();
            name.clear();
            email.clear();
            kinship.clear();
            kinship.setItems(kinshipFromAPI);
            percentage.clear();
            phone2.clear();
            phone1.clear();
        }
    }

    public void configureUpdate(){

        update.addClickListener(buttonClickEvent -> {
            Notification.show("Updated Successfully");
            if(beneficiary!=null){
                service.updateBeneficiary(String.valueOf(beneficiary.getPersonId()), name.getValue(), kinship.getValue(), percentage.getValue(), date, id.getValue(), email.getValue(), phone1.getValue(), phone2.getValue());
            }
        });

    }
}
