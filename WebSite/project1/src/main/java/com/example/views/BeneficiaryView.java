package com.example.views;

import com.example.pojos.Beneficiary;
import com.example.services.Services;
import com.example.views.forms.AddBeneficiaryForm;
import com.example.views.forms.AddPersonForm;
import com.example.views.forms.EditBeneficiaryForm;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.button.ButtonVariant;
import com.vaadin.flow.component.dependency.CssImport;
import com.vaadin.flow.component.grid.Grid;
import com.vaadin.flow.component.grid.GridVariant;
import com.vaadin.flow.component.html.H1;
import com.vaadin.flow.component.html.Label;
import com.vaadin.flow.component.icon.Icon;
import com.vaadin.flow.component.icon.VaadinIcon;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.router.Route;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;

@Route(value = "beneficiary")
@CssImport("./styles/shared-styles.css")
public class BeneficiaryView extends VerticalLayout {

    private final AddBeneficiaryForm addBeneficiaryForm;
    private final EditBeneficiaryForm editBeneficiaryForm;
    private final AddPersonForm addPersonForm;
    private final Grid<Beneficiary> dataGrid = new Grid<>(Beneficiary.class);
    private ArrayList<Beneficiary> beneficiaries;

    private final ArrayList<Beneficiary> selectedBeneficiaries = new ArrayList<>();
    private Beneficiary selectedBeneficiary;

    private final Services service;

    private final Label warningMessage = new Label("ALERTA: La suma de los beneficiarios no es 100");

    private boolean button3Selected = false;

    private final Button button = new Button("Agregar Beneficiarios");
    private final Button button2 = new Button("Editar Beneficiarios");
    private final Button button5 = new Button("Agregar Persona");

    private final Button button3 = new Button("Eliminar Beneficiarios");
    private final Button button4 = new Button(new Icon(VaadinIcon.TRASH));

    private final VerticalLayout verticalLayout = new VerticalLayout();

    public BeneficiaryView(@Autowired Services service){
        this.service = service;
        beneficiaries = service.getBeneficiaries();

        editBeneficiaryForm = new EditBeneficiaryForm(service);
        editBeneficiaryForm.setBeneficiaryView(this);

        addBeneficiaryForm = new AddBeneficiaryForm(service);
        addBeneficiaryForm.setBeneficiaryView(this);

        addPersonForm = new AddPersonForm(service);
        addPersonForm.setBeneficiaryView(this);

        H1 h1 = new H1("Beneficiarios");
        warningMessage.addClassName("warningLabel");
        verticalLayout.add(h1, warningMessage);

        HorizontalLayout horizontalLayout = new HorizontalLayout();

        configureButton1();
        configureButton2();
        configureButton3();
        configureButton4();
        configureButton5();


        horizontalLayout.add(button, button2, button3, button5, button4);

        configureDataGrid();

        setSizeFull();
        HorizontalLayout gridLayout = new HorizontalLayout();
        gridLayout.setSizeFull();

        gridLayout.add(dataGrid, addBeneficiaryForm, editBeneficiaryForm, addPersonForm);

        checkBeneficiaryAddition();

        add(verticalLayout, horizontalLayout, gridLayout);

    }

    public void checkBeneficiaryAddition() {
        int sum = 0;
        for (Beneficiary beneficiary : beneficiaries) {
            sum += beneficiary.getPercentage();
        }

        warningMessage.setVisible(sum < 100);
    }

    public void configureDataGrid(){
        dataGrid.setSizeFull();
        dataGrid.setSelectionMode(Grid.SelectionMode.SINGLE);
        dataGrid.addThemeVariants(GridVariant.LUMO_ROW_STRIPES, GridVariant.MATERIAL_COLUMN_DIVIDERS);
        dataGrid.setVerticalScrollingEnabled(true);
        dataGrid.setColumns("name", "physicalIdValue","birthday","percentage","kinshipId","email","num1","num2");
        dataGrid.getColumnByKey("physicalIdValue").setHeader("Id Number");
        dataGrid.getColumnByKey("kinshipId").setHeader("Codigo de Parentesco");
        dataGrid.getColumns().forEach(col -> col.setAutoWidth(true));

        //Notification.show(String.valueOf(dataGrid.getColumns().size()));

        if(service.getBeneficiaries().size()>=3){
            button.setEnabled(false);
        }

        dataGrid.asSingleSelect().addValueChangeListener(event -> {
            button2.setEnabled(true);
            if(event.getValue()!=null){
                editBeneficiaryForm.setBeneficiary(event.getValue());
            } else {
                editBeneficiaryForm.setBeneficiary(null);
            }

        });

        dataGrid.setItems(beneficiaries);
    }

    public void updateDataGrid(){
        beneficiaries = service.getBeneficiaries();
        dataGrid.setItems(beneficiaries);
        if(service.getBeneficiaries().size()>=3){
            button.setEnabled(false);
        }
    }

    private void configureButton1(){
        button.addThemeVariants(ButtonVariant.LUMO_PRIMARY);
        button.addClickListener(event ->{
            editBeneficiaryForm.setVisible(false);
            addPersonForm.setVisible(false);
            addBeneficiaryForm.setVisible(true);
        });
    }

    private void configureButton2(){
        button2.addThemeVariants(ButtonVariant.LUMO_PRIMARY);
        button2.addClickListener(buttonClickEvent -> {
            addBeneficiaryForm.setVisible(false);
            addPersonForm.setVisible(false);
            editBeneficiaryForm.setVisible(true);
        });
    }

    private void configureButton3(){
        button3.addThemeVariants(ButtonVariant.LUMO_ERROR);
        button3.addClickListener(buttonClickEvent -> {
            addBeneficiaryForm.setVisible(false);
            editBeneficiaryForm.setVisible(false);
            addPersonForm.setVisible(false);
            if(!button3Selected){

                button3Selected = true;
                button3.addThemeVariants(ButtonVariant.LUMO_PRIMARY);
                button4.setVisible(true);

                button.setEnabled(false);
                button2.setEnabled(false);
                button5.setEnabled(false);

                dataGrid.setSelectionMode(Grid.SelectionMode.MULTI);

                dataGrid.asMultiSelect().addSelectionListener(multiSelectionEvent -> {
                    if(multiSelectionEvent.getFirstSelectedItem().isPresent()){
                        //Notification.show(multiSelectionEvent.getFirstSelectedItem().get().getName());
                        selectedBeneficiary = multiSelectionEvent.getFirstSelectedItem().get();
                        selectedBeneficiaries.addAll(multiSelectionEvent.getValue());
                    } else {
                        selectedBeneficiary = null;
                        selectedBeneficiaries.clear();
                    }
                });

            } else {
                button3.removeThemeVariants(ButtonVariant.LUMO_PRIMARY);
                button3Selected = false;
                button.setEnabled(true);
                button2.setEnabled(true);
                button5.setEnabled(true);
                button4.setVisible(false);

                configureDataGrid();
            }
        });
    }

    private void configureButton4(){
        button4.setVisible(false);
        button4.addThemeVariants(ButtonVariant.LUMO_ERROR, ButtonVariant.LUMO_PRIMARY);

        button4.addClickListener(buttonClickEvent -> {
            button3.removeThemeVariants(ButtonVariant.LUMO_PRIMARY);
            button3Selected = false;
            button.setEnabled(true);
            button2.setEnabled(true);
            button4.setVisible(false);

            service.deleteBeneficiary(selectedBeneficiaries);
            selectedBeneficiaries.clear();

            updateDataGrid();
            configureDataGrid();
        });
    }

    private void configureButton5() {
        button5.addClickListener(buttonClickEvent -> {
            addBeneficiaryForm.setVisible(false);
            editBeneficiaryForm.setVisible(false);
            addPersonForm.setVisible(true);
        });
    }

}
