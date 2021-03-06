//
//  LipoAnalyzer.swift
//  JolkCore
//
//  Created by Kenneth Endfinger on 12/27/20.
//

import AnyCodable
import Foundation

public class LipoAnalyzer: ExecutableAnalyzer {
    public init() {}

    public func analyze(_ url: URL, _ output: AnalysisOutput) throws {
        let result = try ProcessRunner.run("/usr/bin/lipo", [
            "-archs",
            url.path
        ])
        let archInfoStrings = result.standardOutput.components(separatedBy: " ")
        var arches: [String] = []

        for archInfo in archInfoStrings {
            let cleanArchInfo = archInfo.trimmingCharacters(in: CharacterSet([
                "\n",
                " "
            ]))

            if cleanArchInfo.isEmpty {
                continue
            }

            arches.append(cleanArchInfo)
        }

        if arches.isEmpty {
            output.isNotExecutable()
        } else {
            output.set("lipo.architectures", AnyCodable(arches))
        }
    }

    public func name() -> String {
        return "lipo"
    }
}
