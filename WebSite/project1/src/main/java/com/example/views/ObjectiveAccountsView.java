package com.example.views;

import com.example.pojos.ObjectiveAccount;
import com.example.services.Services;
import com.example.views.forms.AddObjectiveAccountForm;
import com.example.views.forms.EditObjectiveAccountForm;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.button.ButtonVariant;
import com.vaadin.flow.component.dependency.CssImport;
import com.vaadin.flow.component.grid.Grid;
import com.vaadin.flow.component.grid.GridVariant;
import com.vaadin.flow.component.html.H1;
import com.vaadin.flow.component.icon.Icon;
import com.vaadin.flow.component.icon.VaadinIcon;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.component.textfield.TextField;
import com.vaadin.flow.router.Route;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;

@Route(value = "objective")
@CssImport("./styles/shared-styles.css")
public class ObjectiveAccountsView extends VerticalLayout {

    private final Grid<ObjectiveAccount> dataGrid = new Grid<>(ObjectiveAccount.class);

    private final Services services;

    private final Button addObjectiveAccount = new Button("Agregar Cuenta");
    private final Button editObjectiveAccount = new Button("Editar Cuenta");

    private final Button button3 = new Button("Eliminar Beneficiarios");
    private final Button button4 = new Button(new Icon(VaadinIcon.TRASH));

    private boolean button3Selected = false;
    private final ArrayList<ObjectiveAccount> selectedObjectiveAccounts = new ArrayList<>();

    private final AddObjectiveAccountForm addObjectiveAccountForm;
    private final EditObjectiveAccountForm editObjectiveAccountForm;

    public ObjectiveAccountsView(@Autowired Services services) {
        this.services = services;
        this.addObjectiveAccountForm = new AddObjectiveAccountForm(services, this);
        this.editObjectiveAccountForm = new EditObjectiveAccountForm(services, this);

        HorizontalLayout horizontalLayout = new HorizontalLayout(addObjectiveAccount, editObjectiveAccount, button3, button4);
        H1 h1 = new H1("Cuentas Objetivo");
        configureDataGrid();
        configureAddObjectiveAccount();
        configureEditObjectiveAccount();
        configureButton3();
        configureButton4();
        setSizeFull();

        setSizeFull();
        HorizontalLayout gridLayout = new HorizontalLayout();
        gridLayout.setSizeFull();

        gridLayout.add(dataGrid, addObjectiveAccountForm, editObjectiveAccountForm);

        add(h1, horizontalLayout, gridLayout);
    }

    private void configureEditObjectiveAccount() {
        editObjectiveAccount.setVisible(true);
        editObjectiveAccount.setEnabled(false);
        editObjectiveAccount.addClickListener(buttonClickEvent -> {
            editObjectiveAccountForm.setVisible(true);
            addObjectiveAccountForm.setVisible(false);
        });
    }

    private void configureAddObjectiveAccount() {
        addObjectiveAccount.setVisible(true);
        addObjectiveAccount.setEnabled(true);
        addObjectiveAccount.addClickListener(buttonClickEvent -> {
            addObjectiveAccountForm.setVisible(true);
            editObjectiveAccountForm.setVisible(false);
        });
    }


    private void configureDataGrid() {
        dataGrid.setItems(services.getObjectiveAccounts());
        dataGrid.setSizeFull();
        dataGrid.setSelectionMode(Grid.SelectionMode.SINGLE);
        dataGrid.addThemeVariants(GridVariant.LUMO_ROW_STRIPES, GridVariant.MATERIAL_COLUMN_DIVIDERS);
        dataGrid.setVerticalScrollingEnabled(true);
        dataGrid.getColumns().forEach(col -> col.setAutoWidth(true));
        dataGrid.asSingleSelect().addValueChangeListener(event -> {
            editObjectiveAccount.setEnabled(true);
            if(event.getValue()!=null){
                editObjectiveAccountForm.setObjectiveAccount(event.getValue());
            } else {
                editObjectiveAccountForm.setObjectiveAccount(null);
            }
        });
    }

    public void updateDataGrid() {
        dataGrid.setItems(services.getObjectiveAccounts());
    }

    private void configureButton3(){
        button3.addThemeVariants(ButtonVariant.LUMO_ERROR);
        button3.addClickListener(buttonClickEvent -> {
            addObjectiveAccountForm.setVisible(false);
            editObjectiveAccountForm.setVisible(false);
            if(!button3Selected){

                button3Selected = true;
                button3.addThemeVariants(ButtonVariant.LUMO_PRIMARY);
                button4.setVisible(true);

                addObjectiveAccount.setEnabled(false);
                editObjectiveAccount.setEnabled(false);

                dataGrid.setSelectionMode(Grid.SelectionMode.MULTI);
                dataGrid.asMultiSelect().addSelectionListener(multiSelectionEvent -> {
                    if(multiSelectionEvent.getFirstSelectedItem().isPresent()){
                        //Notification.show(multiSelectionEvent.getFirstSelectedItem().get().getName());
                        selectedObjectiveAccounts.addAll(multiSelectionEvent.getValue());
                    } else {
                        selectedObjectiveAccounts.clear();
                    }
                });

            } else {
                button3.removeThemeVariants(ButtonVariant.LUMO_PRIMARY);
                button3Selected = false;
                addObjectiveAccount.setEnabled(true);
                editObjectiveAccount.setEnabled(true);
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
            addObjectiveAccount.setEnabled(true);
            editObjectiveAccount.setEnabled(true);
            button4.setVisible(false);

            services.deleteObjectiveAccounts(selectedObjectiveAccounts);
            selectedObjectiveAccounts.clear();

            updateDataGrid();
            configureDataGrid();
        });
    }
}
