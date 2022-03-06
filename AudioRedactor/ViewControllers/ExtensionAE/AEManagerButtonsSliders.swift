//
//  AEManagerButtonsSliders.swift
//  AudioEngine
//
//  Created by Александр Панин on 21.02.2022.
//

import UIKit

extension AudioEngineViewController {
    
    // MARK: - обработка кнопок плеера
    
    @objc func pressEffectButtons(_ sender: UIButton) {
        guard let type = ButtonsEffect(rawValue: sender.tag) else { return }

        switch type {
        case .exit:
            hiddenEffectView()
            clearIsEditing()
            tableViewNode.reloadData()
        case .volume:
            typeButtosEffect = .volume
            setupColorButtonPressedEffect(track: activeEffectNode, type: typeButtosEffect)
            return
        case .eq:
            typeButtosEffect = .eq
            setupColorButtonPressedEffect(track: activeEffectNode, type: typeButtosEffect)
            return
        case .reverb:
            typeButtosEffect = .reverb
            setupColorButtonPressedEffect(track: activeEffectNode, type: typeButtosEffect)
            return
        case .delay:
            typeButtosEffect = .delay
            setupColorButtonPressedEffect(track: activeEffectNode, type: typeButtosEffect)
            return
        }
    }
    
    @objc func pressEditorButtons(_ sender: UIButton) {
        guard let type = ButtonsEditor(rawValue: sender.tag) else { return }
        switch type {
        case .effect:
            if isActiveAddPlayer {
                viewEffect.isHidden = false
                dataPlayingNodes[activeEffectNode].isEditing = true
                tableViewNode.reloadData()
            }
        case .copy:
            return
        case .cut:
            return
        case .off:
            return
        case .on:
            return
        case .trash:
            return
        }
    }
    
    // MARK: - обработка кнопок эффектов
    
    @objc func pressPlayerButtons(_ sender: UIButton) {
        guard let type = ButtonsPlayer(rawValue: sender.tag) else { return }
        
        switch type {
        case .gobackward:
            seekButton(to: -10)
        case .backward:
            return
        case .play:
            playButton()
        case .forward:
            return
        case .goforward:
            seekButton(to: 10)
        }
    }
    
    // MARK: - обработка слайдера
    // сохранение значений в массиве и передача данных в функции установок значений
    @objc func turnEffectSlider(_ sender: UISlider) {
        switch typeButtosEffect {
        case .exit:
            return
        case .volume:
            tracksSlidersValue[activeEffectNode].slidersValue.volume = sender.value
        case .eq:
            tracksSlidersValue[activeEffectNode].slidersValue.eq = sender.value
        case .reverb:
            tracksSlidersValue[activeEffectNode].slidersValue.reverb = sender.value
        case .delay:
            tracksSlidersValue[activeEffectNode].slidersValue.delay = sender.value
        }
        setupEffectValue()
    }
    // менеджер передачи значений типа сладера в функцию устанок значений
    func setupEffectValue() {
        switch typeButtosEffect {
        case .exit:
            return
        case .volume:
            editingVolume(tracksSlidersValue[activeEffectNode].slidersValue.volume)
        case .eq:
            editingEQ(tracksSlidersValue[activeEffectNode].slidersValue.eq)
        case .reverb:
            editingReverb(tracksSlidersValue[activeEffectNode].slidersValue.reverb)
        case .delay:
            editingDelay(tracksSlidersValue[activeEffectNode].slidersValue.delay)
        }
    }
    // установка громкости
    func editingVolume(_ value: Float) {
        dataPlayingNodes[activeEffectNode].audioPlayerNode.volume = value
    }
    // установка среза низкой частоты
    func editingEQ(_ value: Float) {
            let bands = dataPlayingNodes[activeEffectNode].equalizer.bands
            bands[0].frequency = value * value * value / 10 // гипербола значений обработки частоты и положения слайдера
    }
    // установка объемного эффекта
    func editingReverb(_ value: Float) {
        dataPlayingNodes[activeEffectNode].reverb.wetDryMix = value
    }
    // установка времени задержки для эха
    func editingDelay(_ value: Float) {
        dataPlayingNodes[activeEffectNode].delayEcho.delayTime = Double(value)
    }
}
