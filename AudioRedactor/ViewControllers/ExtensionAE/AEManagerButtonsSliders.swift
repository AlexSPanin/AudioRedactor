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
        guard let frame = activeEffectFrame else { return }
        switch type {
        case .exit:
            hiddenEffectView()
            clearIsEditingFrames()
            tableViewNode.reloadData()
        case .volume:
            typeButtosEffect = .volume
            setupColorButtonPressedEffect(frame: frame, type: typeButtosEffect)
            return
        case .eq:
            typeButtosEffect = .eq
            setupColorButtonPressedEffect(frame: frame, type: typeButtosEffect)
            return
        case .reverb:
            typeButtosEffect = .reverb
            setupColorButtonPressedEffect(frame: frame, type: typeButtosEffect)
            return
        case .delay:
            typeButtosEffect = .delay
            setupColorButtonPressedEffect(frame: frame, type: typeButtosEffect)
            return
        }
    }
    
    @objc func pressEditorButtons(_ sender: UIButton) {
        guard let frame = activeEffectFrame else { return }
        guard let type = ButtonsEditor(rawValue: sender.tag) else { return }
        switch type {
        case .effect:
            if isActiveAddPlayer {
                viewEffect.isHidden = false
                frame.isEditingFrame = true
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
        guard let effectFrame = activeEffectFrame?.effectFrame else { return }
        switch typeButtosEffect {
        case .exit:
            return
        case .volume:
            effectFrame.volume = sender.value
        case .eq:
            effectFrame.eqHight = sender.value
        case .reverb:
            effectFrame.reverb = sender.value
        case .delay:
            effectFrame.delay = sender.value
        }
        setupEffectValue()
    }
    // менеджер передачи значений типа сладера в функцию устанок значений
    func setupEffectValue() {
        guard let effectFrame = activeEffectFrame?.effectFrame else { return }
        switch typeButtosEffect {
        case .exit:
            return
        case .volume:
            editingVolume(effectFrame.volume)
        case .eq:
            editingEQ(effectFrame.eqHight)
        case .reverb:
            editingReverb(effectFrame.reverb)
        case .delay:
            editingDelay(effectFrame.delay)
        }
    }
    // установка громкости
    func editingVolume(_ value: Float) {
        guard let frame = activeEffectFrame else { return }
        frame.playerFrame.volume = value
    }
    // установка среза низкой частоты
    func editingEQ(_ value: Float) {
        guard let frame = activeEffectFrame else { return }
        let bands = frame.equalizerFrame.bands
        bands[0].frequency = value * value * value / 10 // гипербола значений обработки частоты и положения слайдера
    }
    // установка объемного эффекта
    func editingReverb(_ value: Float) {
        guard let frame = activeEffectFrame else { return }
        frame.reverbFrame.wetDryMix = value
    }
    // установка времени задержки для эха
    func editingDelay(_ value: Float) {
        guard let frame = activeEffectFrame else { return }
        frame.delayEchoFrame.delayTime = Double(value)
    }
}
